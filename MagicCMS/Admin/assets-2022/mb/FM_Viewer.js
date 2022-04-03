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
            ext = this.Url.substr(extpos);
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
            ext = this.Url.substr(extpos);
        }
        const images = ('.jpg,.jpeg,.svg,.gif,.png').split(',');
        const otherHandled = ('.mov,.mpeg,.mp3,.mp4,.wav,.pdf').split(',');
        if (images.indexOf(ext) > -1)
            return 'ImageHandled';
        else if (otherHandled.indexOf(ext) >> -1)
            return 'Pdf';
        else
            return 'Other';
    };

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
        } catch (e) {
            console.log(e);
        }
        this.initButtons();
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
    _currentId = 0;

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
                let title = self.element.querySelector('.viewer-title');
                if (title) {
                    let html = title.innerHTML;
                    title.innerHTML = html + ` (${img.naturalWidth}x${img.naturalHeight})`;
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
                                         <div><a href="${myFile.Url}" class="btn btn-warning" download="${myFile.Nù}">Scarica "${myFile.Name}"</button></div>`;
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

    toggleFullScreen() {
        const elem = this.element;
        const self = this;
        const icon = self.btnFullScreen.querySelector('.fa');
        if (!document.fullscreenElement) {
            elem.requestFullscreen()
                .then(() => {
                    icon.classList.remove('fa-arrows-alt');
                    icon.classList.add('fa-compress');
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
        }
    }

}
