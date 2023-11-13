import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["progress", "time", "player", "play", "pause"];
  static outlets = ["track"];
  static values = { duration: Number, track: String };
  static classes = ["playing"];

  connect() {
    if (this.playerTarget) {
      this.setupAudioListeners();
    }
  }

  disconnect() {
    if (this.playerTarget) {
      this.removeAudioListeners();
    }
  }

  initialize() {
    this.durationValue = this.playerTarget.duration
    this.handleTimeUpdate = this.handleTimeUpdate.bind(this);
    this.handleEnded = this.handleEnded.bind(this);
    this.playing = false;
  }

  play() {
    this.playTarget.classList.add("hidden");
    this.pauseTarget.classList.remove("hidden")
    this.playerTarget.play();
    this.handleTimeUpdate();
    this.playing = true;
  }

  pause() {
    this.pauseTarget.classList.add("hidden");
    this.playTarget.classList.remove("hidden")
    this.playerTarget.pause();
    this.playing = false;
  }

  seek(e) {
    const position =
      (e.offsetX / e.currentTarget.offsetWidth) * this.durationValue;
    this.playerTarget.fastSeek(position);
  }

  handleEnded() {
    this.pause();

    // if (this.nextTrackUrlValue) {
    //   this.fetchNextTrack(this.nextTrackUrlValue);
    // }
  }

  handleTimeUpdate() {
    const currentTime = this.playerTarget.currentTime;

    this.updateProgress(currentTime);
  }

  updateProgress(currentTime) {
    const percent = (currentTime * 100) / this.durationValue;

    if (this.hasProgressTarget) this.progressTarget.value = percent;
    if (this.hasTimeTarget)
      this.timeTarget.textContent = secondsToDuration(currentTime);
  }

  disposeAudio() {
    if (!this.playerTarget) return;

    this.removeAudioListeners();
    this.pause();
    this.updateProgress(0);

    delete this.playerTarget;
  }

  setupAudioListeners() {
    this.playerTarget.addEventListener("timeupdate", this.handleTimeUpdate);
    this.playerTarget.addEventListener("ended", this.handleEnded);
  }

  removeAudioListeners() {
    this.playerTarget.removeEventListener("timeupdate", this.handleTimeUpdate);
    this.playerTarget.removeEventListener("ended", this.handleEnded);
  }
}
