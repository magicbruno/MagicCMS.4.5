class GestioneMappa {
    modalContainer = null;
    mapCanvas = null;
    addressFieldAutocomplete = null;
    latLangHiddenField = null;
    searchButton = null;
    map = null;
    theMaker = null;
    geocoder = null;

    constructor(selOrEl) {
        this.modalContainer = this.toElement(selOrEl);
        this.mapCanvas = this.modalContainer.querySelector('.map-canvas');
        this.addressFieldAutocomplete = this.modalContainer.querySelector('[data-map="google-autocomplete"]');
        this.latLangHiddenField = this.modalContainer.querySelector('[data-map="lat-lng"]');
        this.searchButton = this.modalContainer.querySelector('[data-action="geo-search"]');
        this.geocoder = new google.maps.Geocoder();
        this.init();
    }

    init() {
        this.initMap();
        this.addListeners();
    }

    initMap() {
        const self = this;
        const mapOptions = {
            zoom: 16,
            //center: {address: "Roma, Italia"},
            mapTypeId: 'roadmap',
            disableDefaultUI: false,
            scrollwheel: true,
            draggable: true,
            mapTypeControl: true,
            streetViewControl: true,
            rotateControl: true,
            scaleControl: true,
            fullscreenControl: false
        };
        this.map = new google.maps.Map(this.mapCanvas, mapOptions);
        this.theMaker = new google.maps.Marker({
            position: self.map.getCenter(),
            map: self.map,
            title: 'Scegli una posizione',
            draggable: true // Abilita il trascinamento del marker
        });
        const autocomplete = new google.maps.places.Autocomplete(this.addressFieldAutocomplete);
        autocomplete.bindTo('bounds', this.map);
    }

    addListeners() {
        const self = this;
        google.maps.event.addListener(this.theMaker, 'dragend', event => {
            const newPosition = self.theMaker.getPosition(); // Nuova posizione del marker dopo il drag
            self.geocodeAddress({location: newPosition}).then((result)=> {
                if (result){
                    self.map.setCenter(result.geometry.location);
                    self.theMaker.setPosition(result.geometry.location);
                    self.addressFieldAutocomplete.value = result.formatted_address;
                    self.latLangHiddenField.value = result.geometry.location.lat() + ',' + result.geometry.location.lng();
                }              
            }).catch(error => {
                swal.fire ({
                    title: 'Si è verificato un errore.',
                    icon: 'error',
                    text: error
                })
            })
        });

        $(this.modalContainer)
            .on('shown.bs.modal', function (e) {
                google.maps.event.trigger(self.map, "resize", {});

                const btn = e.relatedTarget;
                const selector = btn.dataset.source;
                this.dataset.source = selector;
                let address = document.querySelector(selector).value;
                address = address || "Roma Italy";
                self.addressFieldAutocomplete.value = address ;
                self.searchButton.click();
            })
            .on('hide.bs.modal', function () {
                const selector = this.dataset.source;
                document.querySelector(selector).value = self.latLangHiddenField.value;

        });

        this.searchButton.addEventListener('click', event => {
            event.preventDefault();
            const address = self.addressFieldAutocomplete.value;
            self.geocodeAddress({address: address}).then((result) =>{
                if (result){
                    self.map.setCenter(result.geometry.location);
                    self.theMaker.setPosition(result.geometry.location);
                    self.addressFieldAutocomplete.value = result.formatted_address;
                    self.latLangHiddenField.value = result.geometry.location.lat() + ',' + result.geometry.location.lng();
                } 
            }).catch(error => {
                swal.fire ({
                    title: 'Si è verificato un errore.',
                    icon: 'error',
                    text: error
                })
            })
        })
    }

    geocodeAddress(request) {
        const self = this;
        return new Promise((resolve, reject) => {
            if (typeof request != 'object')
                resolve(null);
            self.geocoder.geocode(request, function (results, status) {
                if (status === 'OK') {
                    resolve(results[0]);
                } else {
                    reject(status);
                }
            });
        })
    }

    /**
     * Se vien passato un selettore restituisce l'elemento corrispondente, altrimenti 
     * l'elemento passato come parametro. Opzionalmente accetto un parametro contenitore
     * @param {string|element} selectorOrElement Elemento o selector passato
     * @param {element} parent (opzionale) per default document
     * @returns 
     */
    toElement(selectorOrElement, parent = document) {
        if (typeof selectorOrElement === 'string')
            return parent.querySelector(selectorOrElement);
        if (typeof selectorOrElement === 'object') {
            if (selectorOrElement.tagName)
                return selectorOrElement;
            else
                return null;
        }
        return null;
    }
}