class MbDateTimePicker {
    dateInput = null;
    timeInput = null;

    constructor(dateInput) {
        if (typeof dateInput == "string") {
            this.dateInput = document.querySelector(dateInput);
        } else if (dateInput instanceof HTMLElement) {
            this.dateInput = dateInput;
        }
        if (this.dateInput) {
            this.init();
        } else {
            throw new Error("MbDateTimePicker: dateInput not found");
        }
    }

    init () {
        this.timeInput =  document.querySelector(this.dateInput.dataset.time);
        const currentDateStr = this.dateInput.dataset.dateiso;
        if (currentDateStr) {
            this.dateInput.value = currentDateStr.slice(0, 10);
            this.timeInput.value = currentDateStr.slice(11, 16);
        }

        this.addListeners();
    }

    addListeners() {
        this.dateInput.addEventListener("change", () => {
            const ora = this.timeInput.value || "00:00";
            if (this.dateInput.value) {
                this.dateInput.dataset.dateiso = `${this.dateInput.value}T${ora}:00.0000000`;
            }
        })
        this.timeInput.addEventListener("change", () => {
            const ora = this.timeInput.value || "00:00";
            if (this.dateInput.value) {
                this.dateInput.dataset.dateiso = `${this.dateInput.value}T${ora}:00.0000000`;
            }
        })
    }
}