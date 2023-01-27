/**
 * FILE VIEWER
 * Bruno Migliaretti 2022
 * */
class MB_File {
    constructor(url) {
        this.Url = url;
        this.Name = this.Url.substr(this.Url.lastIndexOf('/') + 1);
        let extpos = this.Url.lastIndexOf('.');
        let ext = '';
        if (extpos > -1) {
            ext = this.Url.substr(extpos).toLocaleLowerCase();
        }
        this.ext = ext;
        this.directory = this.Url.substr(0, this.Url.lastIndexOf('/'));

    }
    Name = "";
    Url = "";
    ext = "";
    get Type() {
        let extpos = this.Url.lastIndexOf('.');
        let ext = '';
        if (extpos > -1) {
            ext = this.Url.substr(extpos).toLowerCase();
        }
        const images = ('.jpg,.jpeg,.svg,.gif,.png').split(',');
        const otherHandled = ('.mov,.mpeg,.mp3,.mp4,.wav,.pdf').split(',');
        if (images.indexOf(ext) > -1)
            return 'ImageHandled';
        else if (otherHandled.indexOf(ext) > -1)
            return 'Pdf';
        else
            return 'Other';
    };

}

class FM_Cropper {
    constructor(initialWidth) {

    }
    cropper = null;
    image = null;
    width = 1200;
    quality = 0.8;
    type = 'ImageHandled';
    _aspectRatio = 1.778;

    get maxWidth() {
        let naturalWidth = this.cropper.imageData.naturalWidth;
        let imageWidth = this.cropper.imageData.width;
        let cropBoxWidth = this.cropper.cropBoxData.width;
        return Math.round(naturalWidth * (cropBoxWidth / imageWidth));
    }

    get aspectRatio() {
        return this._aspectRatio;
    }

    set aspectRatio(val) {
        let v = val || NaN;
        if (v == 'default')
            v = this.image.naturalWidth / this.image.naturalHeight;

        if (this.cropper) {
            this.cropper.setAspectRatio(v)
        }
        this._aspectRatio = val;
    }

    get height() {
        let ar = this.aspectRatio;
        if (isNaN(ar)) {
            let cropData = this.cropper.getCropBoxData();
            ar = cropData.width / cropData.height;
        }
             
        if (this.width && ar > 0)
            return Math.round(this.width / this.aspectRatio);
        return null;
    }

    crop(image, type, aspectRatio) {
        if (this.cropper) return;
        if (!Cropper) return;
        this.image = image;

        if (aspectRatio)
            this.aspectRatio = aspectRatio;
        else
            this.aspectRatio = image.naturalWidth / image.naturalHeight;
        const self = this;
        return new Promise(resolve => {
            this.initCrop().then(() => {
                self.width = self.maxWidth;
                self.type = type;
                resolve();
            })
        })  
    }

    initCrop() {
        const self = this;
        return new Promise(resolve => {
            self.cropper = new Cropper(self.image, {
                aspectRatio: self.aspectRatio,
                viewMode: 1,
                dragMode: 'move',
                ready: () => {
                    resolve();
                }
            });
        })
    }

    preview() {
        let element = document.createElement('div');
        element.classList.add('fm-viewer');
        element.title = 'Clicca per chiudere l\'anteprima';
        element.style.cursor = 'pointer';
        element.style.overflow = 'auto';
        let canvas = this.cropper.getCroppedCanvas({
            width: this.width,
            height: this.height
        });
        if (this.width > window.visualViewport.width)
            element.style.justifyContent = 'flex-start';
        if (this.height > window.visualViewport.height)
            element.style.alignItems = 'flex-start';
        let imageData;
        if (this.type == 'Png') {
            imageData = canvas.toDataURL('image/png');
        } else {
            imageData = canvas.toDataURL('image/jpeg', this.quality);
        }

        let img = document.createElement('img');
        img.style.setProperty('max-width', 'none', 'important');
        img.src = imageData;
        element.appendChild(img);
        element.addEventListener('click', event => {
            element.remove();
        });
        document.body.appendChild(element);
    }

    saveCurrentFile(newName, overwrite, url) {
        let canvas = this.cropper.getCroppedCanvas({
            width: this.width,
            height: this.height
        });

        let imageData;
        if (this.type == 'Png') {
            imageData = canvas.toDataURL('image/png');
        } else {
            imageData = canvas.toDataURL('image/jpeg', this.quality);
        }

        let inputData = {
            "OriginalFullName": url,
            "NewName": newName,
            "Overwrite": overwrite,
            "DataUrl": imageData
        }

        var myHeaders = new Headers();
        myHeaders.append("Content-Type", "application/json");

        myHeaders.append("Authorization", "Bearer " + Cookies.get('MB_AuthToken'));
        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: JSON.stringify(inputData),
            redirect: 'follow'
        };

        return new Promise((resolve, reject) => {
            fetch("/api/UploadBase64", requestOptions)
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        resolve(result.data)
                    }
                    else
                        reject(result.msg);
                })
                .catch(error => reject(error));
        })

    }

    close() {
        if (this.cropper) {
            this.cropper.destroy();
            this.cropper = null;
        }
    }
}

class FM_Viewer {
    constructor(selector) {
        try {
            this.element = document.querySelector(selector);
            this.btnChoose = this.element.querySelector('[data-action="select-file"]');
            this.btnDownload = this.element.querySelector('[data-action="download-file"]');
            this.btnPrevious = this.element.querySelector('[data-action="previous"]');
            this.btnNext = this.element.querySelector('[data-action="next"]');
            this.btnClose = this.element.querySelector('[data-action="close-viewer"]');
            this.btnFullScreen = this.element.querySelector('[data-action="toggle-fullscreen"]');
            this.btnCropFile = this.element.querySelector('[data-action="crop-file"]');
            this.btnCloseCropper = this.element.querySelector('[data-action="close-cropper"]');
            this.selectAspectRatio = this.element.querySelector('[data-action="cropper-aspectratio"]');
            this.inputCropperWidth = this.element.querySelector('[data-action="cropper-width"]');
            this.inputCropperQuality = this.element.querySelector('[data-action="cropper-quality"]');
            this.btnCropperPreview = this.element.querySelector('[data-action="cropper-preview"]');
            this.btnCropperSave = this.element.querySelector('[data-action="cropper-save"]');
            this.btnCropperSaveCopy = this.element.querySelector('[data-action="cropper-savecopy"]');
        } catch (e) {
            console.log(e);
        }
        this.initButtons();
        this.cropper = new FM_Cropper(1200);
    }

    element = null;
    files = [];
    _currentFile = -1;
    btnNext = null;
    btnPrevious = null;
    btnChoose = null;
    btnClose = null;
    btnDownload = null;
    btnFullScreen = null;
    btnCropFile = null;
    btnCloseCropper = null;
    selectAspectRatio = null;
    inputCropperWidth = null;
    inputCropperQuality = null;
    btnCropperPreview = null;
    btnCropperSave = null;
    btnCropperSaveCopy = null;
    _currentId = 0;
    imageHeight = 0;
    imageWidth = 0;
    fileManager = null;
    cropper = null;

    set currentId(val) {
        this._currentId = val;
        for (var i = 0; i < this.files.length; i++) {
            if (this.files[i].Id == val) {
                this.currentFile = i;
                return;
            }
        }
        this.currentFile = -1;
    }

    get currentFile() {
        return this._currentFile;
    }

    set currentFile(val) {
        this._currentFile = val;
        if (val < 0 || val >= this.files.length) return;
        let title = this.element.querySelector('.viewer-title');
        if (title && val >= 0)
            title.innerHTML = this.files[val].Url || '';

    }

    get nextItem() {
        this.currentFile++;
        if (this.currentFile >= this.files.length)
            this.currentFile = 0;
        if (this.files[this.currentFile].Type == 'Folder')
            return this.nextItem;
        return this.currentFile;
    }

    get previousItem() {
        this.currentFile--;
        if (this.currentFile < 0)
            this.currentFile = this.files.length - 1;
        if (this.files[this.currentFile].Type == 'Folder')
            return this.previousItem;
        return this.currentFile;
    }

    


    initButtons() {
        const self = this;
        if (this.btnClose)
            this.btnClose.addEventListener('click', function () {
                self.hide();
            });
        if (this.btnNext)
            this.btnNext.addEventListener('click', function () {
                self.next();
            });
        if (this.btnPrevious)
            this.btnPrevious.addEventListener('click', function () {
                self.previous();
            });
        if (this.btnDownload)
            this.btnDownload.addEventListener('click', function () {
                self.downloadCurrent();
            });
        if (this.btnFullScreen)
            this.btnFullScreen.addEventListener('click', function () {
                self.toggleFullScreen();
            });
        if (this.btnCropFile)
            this.btnCropFile.addEventListener('click', function () {
                self.cropFile();
            });
        if (this.btnCloseCropper)
            this.btnCloseCropper.addEventListener('click', function () {
                self.closeCropper();
            });
        if (this.btnCropperPreview)
            this.btnCropperPreview.addEventListener('click', event => {
                self.cropper.preview();
            })
        if (this.selectAspectRatio)
            this.selectAspectRatio.addEventListener('change', event => {
                let val = self.selectAspectRatio.value;
                if (val != 'default')
                    val = parseFloat(val);
                self.setAspectRatio(val);
            });

        if (this.inputCropperWidth) {
             this.inputCropperWidth.addEventListener('keypress', event => {
                if (event.altKey || event.ctrlKey || event.shiftKey || event.metaKey) {
                    event.preventDefault();
                    return;
                };
                if ('qwertyuiopè+asdfghjklòàù<zxcvbnm,.-'.indexOf(event.key) > -1) {
                    event.preventDefault();
                    return;
                }
            });
            this.inputCropperWidth.addEventListener('change', event => {
                let val = self.inputCropperWidth.value;
                
                if (val > self.cropper.maxWidth)
                    Swal.fire({
                        text: 'Stai ingrandendo l\'immagine. Potrebbe esserci perdita di qualità.',
                        title: 'Attenzione!',
                        icon: 'warning',
                        showDenyButton: true,
                        showCancelButton: false,
                        confirmButtonText: 'Continua',
                        denyButtonText: `Correggi`,
                    }).then((result) => {
                        /* Read more about isConfirmed, isDenied below */
                        if (result.isConfirmed) {
                            self.cropper.width = val;
                        } else if (result.isDenied) {
                            self.inputCropperWidth.value = self.cropper.maxWidth;
                            self.inputCropperWidth.focus();
                        }
                    })
                else 
                    self.cropper.width = val;
            })           
        };
        if (this.inputCropperQuality) {
            this.inputCropperQuality.addEventListener('change', event => {
                let val = parseInt(self.inputCropperQuality.value);
                if (isNaN(val))
                    val = 8;
                else if (val > 10)
                    val = 10;
                else if (val <= 0)
                    val = 0;
                self.inputCropperQuality.value = val;
                self.cropper.quality = val / 10;
            })
        };
        if (this.btnCropperSave) {
            this.btnCropperSave.addEventListener('click',event => self.cropperSave());
        };
        if (this.btnCropperSaveCopy) {
            this.btnCropperSaveCopy.addEventListener('click',event => self.cropperSaveCopy());
        };
    }

    show(indexOrUrl, list) {
        this.element.classList.remove('off-screen');
        this.files = list || [];
        this.render(indexOrUrl);
        if (this.files.length > 1) {
            this.btnNext.classList.remove('disabled');
            this.btnPrevious.classList.remove('disabled');
        } else if (list) {
            this.btnNext.classList.add('disabled');
            this.btnPrevious.classList.add('disabled');
        }

    }

    hide() {
        const self = this;
        if (document.fullscreenElement)
            document.exitFullscreen();
        this.hideCurrentFile().then(esito => self.element.classList.add('off-screen'));
        this.currentFile = -1;
    }

    render(indexOrUrl) {
        const self = this;
        if (Number.isInteger(indexOrUrl)) {
            this.hideCurrentFile()
                .then(esito => {
                    self.currentId = indexOrUrl;
                    this.showCurrentFile().then(esito => {

                    });
                })
        } else {
            this.files.push(new MB_File(indexOrUrl));
            this.currentFile = this.files.length - 1;
            this.showCurrentFile().then(esito => {

            })
        }
    }

    hideCurrentFile(fade) {
        const self = this;
        const myFade = fade || 'fade-out';
        return new Promise(resolve => {
            if (self.currentFile == -1)
                resolve(true);
            else {
                const content = self.element.querySelector('.viewer-content');

                if (content) {
                    content.classList.add(myFade);
                    setTimeout(() => {
                        content.remove();
                        resolve(true);
                    }, 500);
                } else
                    resolve(false);
            }
        })
    }

    showCurrentFile(fade) {
        let myFile = this.files[this.currentFile];
        const myFade = fade || 'fade-in';
        return new Promise(resolve => {
            if (myFile.Type == 'ImageHandled' || myFile.Type == 'Png' || myFile.Type == 'Gif' || myFile.Type == 'Svg')
                this.showCurrentImage(myFade).then(result => {
                    resolve(result);
                });
            else if (myFile.Type == 'Pdf' || myFile.Type == 'Video' || myFile.Type == 'Audio')
                this.showIframe(myFade).then(result => {
                    resolve(result);
                })
            else
                this.showUnHandledFile(myFade).then(result => {
                    resolve(result);
                })
        })

    }

    showCurrentImage(fade) {
        const self = this;
        const myFade = fade || 'fade-in';
        $(self.element).spin();
        let myFile = this.files[this.currentFile];
        return new Promise(resolve => {
            let img = document.createElement('img');
            img.classList.add('viewer-content');
            img.classList.add(myFade);

            img.addEventListener('load', () => {
                self.element.appendChild(img);
                self.imageHeight = img.naturalHeight;
                self.imageWidth = img.naturalWidth;
                let title = self.element.querySelector('.viewer-title');
                if (title) {
                    let html = title.innerHTML;
                    title.innerHTML = html + ` (${self.imageWidth}x${self.imageHeight})`;
                }
                //img.classList.remove('fade-in');
                $(self.element).spin(false);
                setTimeout(() => {
                    img.classList.remove(myFade);
                    resolve(true);
                }, 300);
            });
            img.src = myFile.Url;
        })
    }

    showIframe(fade) {
        const myFade = fade || 'fade-in';
        const self = this;
        $(self.element).spin();
        let myFile = this.files[this.currentFile];
        return new Promise(resolve => {
            let frame = document.createElement('iframe');
            frame.classList.add('viewer-content');
            frame.classList.add(myFade);
            frame.src = myFile.Url;
            self.element.appendChild(frame);
            $(self.element).spin(false);
            setTimeout(() => {
                frame.classList.remove(myFade);
                resolve(true);
            }, 300);
        })
    }

    showUnHandledFile(fade) {
        const myFade = fade || 'fade-in';
        const self = this;
        $(self.element).spin();
        let myFile = this.files[this.currentFile];
        return new Promise(resolve => {
            let div = document.createElement('div');
            div.classList.add('viewer-content');
            div.classList.add('text-white');
            div.classList.add('text-center');
            div.classList.add(myFade);
            div.innerHTML = `<h3>Anteprima non disponibile</h3> 
                                         <p>Viewer non è in grado di visualizzare il file</p>
                                         <div><a href="${myFile.Url}" class="btn btn-warning" download="${myFile.Name}">Scarica "${myFile.Name}"</button></div>`;
            self.element.appendChild(div);
            $(self.element).spin(false);
            setTimeout(() => {
                div.classList.remove(myFade);
                resolve(true);
            }, 300);
        })
    }

    downloadCurrent() {
        let url = this.files[this.currentFile].Url;
        let name = this.files[this.currentFile].Name;
        let link = document.createElement('a');
        link.download = name;
        link.href = url;
        link.click();
    }

    next() {
        const self = this;
        this.hideCurrentFile('fade-left').then(result => {
            self.currentFile = self.nextItem;
            self.showCurrentFile('fade-right');
        })
    }

    previous() {
        const self = this;
        this.hideCurrentFile('fade-right').then(result => {
            self.currentFile = self.previousItem;
            self.showCurrentFile('fade-left');
        })
    }

    cropFile() {
        let myFile = this.files[this.currentFile];
        if (!(myFile.Type == 'ImageHandled' || myFile.Type == 'Png'))
            swal.fire({
                title: "Formato non supportato.",
                icon: 'info'
            });
        else {
            let viewerNavbar = this.element.querySelector('.viewer-navbar');
            let cropperNavbar = this.element.querySelector('.cropper-navbar');
            let cropperOption = cropperNavbar.querySelector('.dropdown-menu');
            viewerNavbar.classList.add('d-none');
            cropperNavbar.classList.remove('d-none');
            let image = this.element.querySelector('.viewer-content');
            const self = this;
            this.cropper.crop(image, myFile.Type).then(() => {
                self.inputCropperWidth.value = self.cropper.width;
                self.inputCropperQuality.value = Math.round(self.cropper.quality * 10);
                let select = cropperOption.querySelector('select');
                if(select)
                    select.value = 'default';
                cropperOption.click();
            });
            
        }
    }

    cropperSave() {
        const self = this;
        this.cropper.saveCurrentFile('', true, this.files[this.currentFile].Url)
            .then(result => {
                Swal.fire({
                    icon: 'success',
                    title: 'Ok!',
                    text: `Il file è stato salvato con successo in:"${result}". 
                           Per effetto della cache il browser potrebbe non visualizzare
                           la versione modificata del file. Per ovviale al problema azzera 
                           la cache.`
                }).then(() => {
                    self.fileManager.reload();
                    self.closeCropper();
                    self.hide();
                });

            })
            .catch(error => Swal.fire({
                icon: 'error',
                title: 'Errore',
                text: error
            }));
    }

    cropperSaveCopy() {
        const self = this;
        let filename = this.files[this.currentFile].Name;
        let nameWithoutExtension = filename.replace(this.files[this.currentFile].Extension, '');
        this.cropper.saveCurrentFile(`${nameWithoutExtension}(${this.cropper.width}x${this.cropper.height})${this.files[this.currentFile].Extension}`,
            false, this.files[this.currentFile].Url)
            .then(result => {
                Swal.fire({
                    icon: 'success',
                    title: 'Ok!',
                    text: `Il file è stato salvato con successo in:"${result}".`
                }).then(() => {
                    self.fileManager.reload();
                    self.closeCropper();
                    self.hide();
                });
            })
            .catch(error => Swal.fire({
                icon: 'error',
                title: 'Errore',
                text: error
            }));
    }

    closeCropper() {
        let viewerNavbar = this.element.querySelector('.viewer-navbar');
        let cropperNavbar = this.element.querySelector('.cropper-navbar');
        viewerNavbar.classList.remove('d-none');
        cropperNavbar.classList.add('d-none');
        this.cropper.close();
    }

    setAspectRatio(val) {
        if (this.cropper)
            this.cropper.aspectRatio = val;
    }

    toggleFullScreen() {
        const elem = this.element;
        const self = this;
        const icon = self.btnFullScreen.querySelector('.fa');
        if (!document.fullscreenElement) {
            elem.requestFullscreen()
                .then(() => {
                    icon.classList.remove('fa-arrows-alt');
                    icon.classList.add('fa-compress');
                    self.btnCropFile.classList.add('disabled');
                })
                .catch(err => {
                    Swal.fire({
                        icon: 'error',
                        text: `Impossibile impostare la modalità "fullscreen": ${err.message} (${err.name})`
                    });
                });
        } else {
            document.exitFullscreen();
            icon.classList.add('fa-arrows-alt');
            icon.classList.remove('fa-compress');
            self.btnCropFile.classList.remove('disabled');
        }
    }

}
