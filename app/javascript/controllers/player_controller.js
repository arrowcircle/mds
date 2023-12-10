import { Controller } from "@hotwired/stimulus"

function secondsToDuration(num) {
  let mins = Math.floor(num / 60);
  let secs = (num | 0) % 60;
  if (mins < 10) mins = "0" + mins;
  if (secs < 10) secs = "0" + secs;
  return `${mins}:${secs}`;
}

export default class extends Controller {
  static targets = ["progress", "time", "duration", "player", "play", "pause"];
  static values = { duration: Number, position: Number, autoplay: Boolean };
  static classes = ["playing"];

  connect() {
    if (this.playerTarget) {
      this.setupAudioListeners();
      this.play();
      if (this.autoplayValue) {
        // this.play();
      }
    }
    if (this.hasDurationTarget && this.playerTarget.duration) {
      this.durationValue = this.playerTarget.duration;
      this.durationTarget.textContent = secondsToDuration(this.playerTarget.duration);
    }
  }

  disconnect() {
    if (this.playerTarget) {
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
    this.playerTarget.currentTime = position;
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
