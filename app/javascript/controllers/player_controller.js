import { Controller } from "@hotwired/stimulus"

function secondsToDuration(num) {
  if (!Number.isFinite(num)) return "--:--";

  let mins = Math.floor(num / 60);
  let secs = (num | 0) % 60;
  if (mins < 10) mins = "0" + mins;
  if (secs < 10) secs = "0" + secs;
  return `${mins}:${secs}`;
}

export default class extends Controller {
  static targets = ["progress", "time", "duration", "player", "play", "pause", "currentTrack"];
  static values = { duration: Number, position: Number, autoplay: Boolean, playlist: Array };
  static classes = ["playing"];

  connect() {
    if (this.hasPlayerTarget) {
      this.setupAudioListeners();

      if (this.hasPositionValue && this.positionValue > 0) {
        this.playerTarget.currentTime = this.positionValue;
      }

      if (this.autoplayValue) {
        this.play();
      } else {
        this.pause();
      }
    }
  }

  disconnect() {
    if (this.hasPlayerTarget) {
      this.playerTarget.pause();
      this.removeAudioListeners();
    }
  }

  initialize() {
    this.handleTimeUpdate = this.handleTimeUpdate.bind(this);
    this.handleEnded = this.handleEnded.bind(this);
    this.handleMetadataLoaded = this.handleMetadataLoaded.bind(this);
    this.playing = false;
  }

  play() {
    if (!this.hasPlayerTarget) return;

    this.playTarget.classList.add("hidden");
    this.pauseTarget.classList.remove("hidden")
    this.playerTarget.play().catch(() => this.pause());
    this.handleTimeUpdate();
    this.playing = true;
  }

  pause() {
    if (!this.hasPlayerTarget) return;

    this.pauseTarget.classList.add("hidden");
    this.playTarget.classList.remove("hidden")
    this.playerTarget.pause();
    this.playing = false;
  }

  seek(e) {
    if (Number.isNaN(this.durationValue) || this.durationValue == 0) return;

    const rect = e.currentTarget.getBoundingClientRect();
    const position =
      ((e.clientX - rect.left) / rect.width) * this.durationValue;
    this.playerTarget.currentTime = position;
    this.handleTimeUpdate();
  }

  handleEnded() {
    this.pause();
  }

  handleTimeUpdate() {
    const currentTime = this.playerTarget.currentTime;
    this.updateProgress(currentTime);
  }

  handleMetadataLoaded(event) {
    this.durationValue = event.target.duration;
    if (this.hasDurationTarget){
      this.durationTarget.textContent = secondsToDuration(this.durationValue);
      this.handleTimeUpdate();
    }
  }

  updateProgress(currentTime) {
    if (currentTime === null) return;
    if (Number.isNaN(this.durationValue) || this.durationValue == 0) return;
    const percent = (currentTime * 100) / this.durationValue;
    if (this.hasProgressTarget) this.progressTarget.value = percent;
    if (this.hasTimeTarget)
      this.timeTarget.textContent = secondsToDuration(currentTime);
    this.updateCurrentTrack(currentTime);
  }

  updateCurrentTrack(currentTime) {
    if (!this.hasCurrentTrackTarget) return;

    const currentTrack = this.currentTrackFor(currentTime);
    this.currentTrackTarget.textContent = currentTrack ? currentTrack.label : "Рассказ";
  }

  currentTrackFor(currentTime) {
    if (!this.hasPlaylistValue) return null;

    const currentMinute = currentTime / 60;

    return this.playlistValue.find((item) => {
      const start = this.parseMinute(item.start);
      const finish = this.parseMinute(item.finish);
      const afterStart = Number.isFinite(start) ? currentMinute >= start : true;
      const beforeFinish = Number.isFinite(finish) ? currentMinute < finish : true;

      return item.label && afterStart && beforeFinish;
    });
  }

  parseMinute(value) {
    if (value === null || value === undefined || value === "") return null;

    return Number(value);
  }

  setupAudioListeners() {
    this.playerTarget.addEventListener("timeupdate", this.handleTimeUpdate);
    this.playerTarget.addEventListener("loadedmetadata", this.handleMetadataLoaded);
    this.playerTarget.addEventListener("ended", this.handleEnded);
  }

  removeAudioListeners() {
    this.playerTarget.removeEventListener("timeupdate", this.handleTimeUpdate);
    this.playerTarget.removeEventListener("loadedmetadata", this.handleMetadataLoaded);
    this.playerTarget.removeEventListener("ended", this.handleEnded);
  }
}
