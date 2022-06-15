namespace :dupes do
  task artists: :environment do
    dupes = {}
    client = MeiliSearch::Client.new('http://127.0.0.1:7700')
    client.delete_index('artists')
    index = client.index('artists')

    index.update_settings({"typoTolerance" => {enabled: false}})
    puts "Indexing artists"
    Artist.find_in_batches do |batch|
      docs = batch.map do |item|
        item.attributes
      end
      index.add_documents(docs)
      print "."
    end
    puts "\n Finished indexing"
    puts "Looking for dupes"

    Artist.find_in_batches do |batch|
      batch.each do |artist|
        results = index.search(name: artist.name)["hits"]
        next if results.size <= 1
        dupes[artist.id] ||= {artist: artist.name, id: artist.id, dupes: []}
        results.each do |item|
          next if item["id"].to_i == artist.id
          dupes[artist.id][:dupes] << {
            id: item["id"],
            name: item["name"],
          }
        end
      end
      print "."
    end
    puts "\n Results:"
    dupes.each do |k, v|
      puts "#{v[:artist]} (#{v[:id]}):"
      v[:dupes].each do |d|
        puts "\t#{d[:name]} (#{d[:id]})"
      end
    end
    puts "Total dupes: #{dupes.keys.size}"
  end

  task tracks: :environment do
    dupes = {}
    client = MeiliSearch::Client.new('http://127.0.0.1:7700')
    client.delete_index('tracks')
    index = client.index('tracks')

    index.update_settings({"typoTolerance" => {enabled: false}})
    puts "Indexing tracks"
    Track.includes(:artist).find_in_batches do |batch|
      docs = batch.map do |item|
        item.attributes.merge(artist: item.artist.name)
      end
      index.add_documents(docs)
      print "."
    end
    puts "\n Finished indexing"
    puts "Looking for dupes"

    Artist.find_in_batches do |batch|
      batch.each do |artist|
        processed_names = {}
        artist.tracks.each do |track|
          next if processed_names[track.name.downcase.strip].present?
          results = index.search(name: track.name, artist_id: track.artist_id)["hits"]
          results.select! { _1["artist_id"] == artist.id }
          next if results.size <= 1
          dupes[track.id] ||= {track: track.name, artist: artist.name, artist_id: track.artist_id, dupes: []}
          results.each do |item|
            next if item["id"].to_i == track.id
            dupes[track.id][:dupes] << {
              id: item["id"],
              name: item["name"],
              artist_id: item["artist_id"],
              artist: artist.name
            }
          end
          processed_names[track.name.downcase.strip] = 1
        end
      end
      print "."
    end
  
    puts "\n Results:"
    dupes.each do |k, v|
      puts "#{k}: #{v.except(:dupes)}"
      v[:dupes].each do |d|
        puts "\t#{d}"
      end
    end
    puts "Total dupes: #{dupes.keys.size}"
  end

  task fix_tracks: :environment do
    FIXES = {
      2997 => [129],
      4384 => [2452, 151],
      854 => [3463],
      4972 => [5333],
      408 => [785],
      4517 => [4598],
      525 => [4597],
      4216 => [135],
      4790 => [139],
      141 => [4328],
      788 => [789],
      4987 => [5227],
      149 => [5045],
      1875 => [152],
      242 => [4440],
      4174 => [611],
      4176 => [5204],
      558=> [5011],
      1349 => [6190],
      4334 => [160, 2448],
      162 => [5440],
      5446 => [5687],
      724 => [2424],
      1922 => [5131],
      186 => [3545],
      187 => [2195],
      544 => [281],
      710 => [6553],
      3403 => [6552],
      4252 => [4282],
      2502 => [4521],
      2500 => [2409],
      5021 => [191],
      2497 => [5254],
      1048 => [2613],
      1839 => [1880],
      1869 => [1881],
      5066 => [6218],
      3008 => [2442],
      1660 => [1299],
      3972 => [1694],
      251 => [518, 2945],
      286 => [253],
      439 => [2559],
      587 => [4359],
      2444 => [2558],
      254 => [4612, 5619],
      256 => [690],
      257 => [691],
      258 => [5804],
      837 => [2372],
      2402 => [2403],
      273 => [2391],
      278 => [574],
      2388 => [4773],
      2830 => [285],
      531 => [3535],
      5237 => [5468],
      377 => [5368],
      3267 => [7055],
      6246 => [3268],
      4590 => [4736],
      262 => [720, 2387],
      722 => [4175],
      410 => [4327],
      3077 => [413, 4090],
      4088 => [415],
      3941 => [2536],
      5223 => [3173],
      6052 => [6966],
      440 => [786],
      494 => [2486],
      500 => [864],
      2470 => [3435],
      3522 => [2473],
      7038 => [5438],
      5893 => [2487],
      522 => [3411],
      3409 => [4295],
      2328 => [2354],
      533 => [6774],
      545 => [542],
      548 => [6025],
      560 => [561],
      2165 => [2891],
      3199 => [579],
      584 => [600],
      703 => [595],
      701 => [596],
      4881=> [2341, 4218],
      622 => [5701],
      624 => [5702],
      650 => [3518],
      5886 => [5926],
      4544 => [6554],
      767 => [768],
      662 => [663],
      5375 => [4435],
      2381 => [6549],
      5372 => [696],
      5370 => [5335],
      4219 => [783],
      4785 => [705],
      2509 => [4290],
      737 => [4249],
      2270 => [778],
      796 => [4607],
      802 => [4039],
      4221 => [2339],
      2940 => [812],
      2762 => [6596],
      1302 => [1300],
      2589 => [4731, 5618],
      4482 => [863],
      1177 => [4822],
      3615 => [930],
      966 => [965],
      1006 => [1005],
      2109 => [5276],
      5126 => [1076],
      4976 => [4011],
      1105 => [2860],
      2299 => [1166, 1202],
      1176 => [4283],
      1211 => [6707],
      4170 => [5097],
      1358 => [1478],
      1479 => [1359],
      1360 => [1480],
      918 => [1383],
      1391 => [1390],
      1451 => [6932],
      1820 => [5720],
      1544 => [1543],
      1548 => [5406],
      3553 => [5448],
      1607 => [5407],
      1702 => [1706],
      5265 => [5399],
      1796 => [6242],
      1813 => [5718],
      1819 => [5719],
      2272 => [3458],
      1826 => [5721],
      988 => [1827],
      1873 => [4808],
      2199 => [3791],
      3779 => [4774],
      1911 => [4846],
      2040 => [4180],
      2107=> [4488],
      2118 => [3410],
      2127 => [4266, 6545],
      2362 => [4265],
      4411 => [4584],
      2197 => [3790],
      2200 => [3081],
      2334 => [5179],
      2351 => [4235],
      5613 => [5610],
      2382 => [6547],
      3528 => [5078],
      2426 => [4046],
      3842 => [3844],
      2624 => [6161],
      868 => [865, 867, 507, 2873],
      2717 => [3111],
      2718 => [3112],
      2776 => [5201],
      1067 => [2779],
      2799 => [3739],
      4296 => [2972],
      3039 => [3719],
      416 => [3245],
      1571 => [4169],
      1580 => [4166],
      2099 => [3080],
      3095 => [3392],
      3101=> [5489],
      4832 => [4849],
      3174 => [7054],
      3177=> [4250],
      4975=> [5334],
      3208=> [3271],
      6546=> [3405],
      4441=> [4380,3406],
      3424=> [5529],
      721=> [3434],
      3512=> [4637],
      2812=> [482,3465,3478],
      4699=> [4744],
      3379=> [3586],
      3610=> [4099],
      4686=> [4687],
      6386=> [6387],
      3800=> [5460],
      1572=> [4093],
      1582=> [4167],
      2096=> [3812],
      3495=> [4117],
      5503=> [4201],
      599=> [5874],
      604=> [4227],
      397=> [776],
      777=> [3412,3606,4301,4269, 3541],
      2360=> [2361,4233],
      3372=> [5876, 399],
      3432=> [4841],
      3541=> [4865, 246],
      3368 => [5878,4410],
      2505 => [2369,4331,2506],
      4513=> [4725],
      4525=> [6868],
      4560=> [4624],
      4416=> [4635],
      5937=> [6212],
      4743 => [5894],
      308 => [309, 5500],
      4758 => [5715],
      5094 => [4793],
      4815 => [5178],
      4950=> [5314,5714],
      2862=> [5393],
      2865=> [5394],
      2866=> [5395],
      2867=> [5396],
      2868=> [5397],
      2869=> [5398],
      5422=> [5436],
      5466=> [6124],
      4776=> [5748,6871],
      6032=> [6895],
      6948=> [6296],
      6878 => [6882],
      1677=> [6414],
      6520=> [6447],
      6825=> [6979],
      6064=> [6569],
      6739=> [6763],
      6827=> [7021],
      6034=> [7023]
    }
    FIXES.each do |output, inputs|
      Playlist.where(track_id: inputs).update_all(track_id: output)
    end
    Track.where(id: FIXES.values.flatten).destroy_all
    Artist.all.each { |a| Artist.reset_counters(a.id, :tracks) }
    Track.all.each { |a| Track.reset_counters(a.id, :playlists) }
  end
end