/**
 * FILE UPLOAD
 * Bruno Migliaretti 2022
 * */
class MB_FileUpload {
    constructor(endpoint, opt) {
        let options = opt || {};
        this.endPoint = endpoint;
        const input = document.createElement('input');
        input.type = 'file';
        input.style.position = 'fixed';
        input.style.top = '-1000px';
        input.multiple = false;
        this.input = input;
        if (options.allowedFileTypes)
            this.allowedFileTypes = options.allowedFileTypes;
        if (options.maxLength)
            this.maxLength = options.maxLength
    }

    allowedFileTypes = ('.jpg,.jpeg,.doc,.docx,.svg,.zip,.gif,.png,.pdf,.rar,.svg,.svgz,.xls,.xlsx,.ppt,.pps,.pptx,.mov,.mpeg,.mp3,.mp4,.wav').split(',');
    endPoint = '';
    input = null;
    maxLength = 50 * 1024 * 1024;

    getFileSingle(destination) {

        this.input.multiple = false;
        const self = this;
        return new Promise((resolve, reject) => {
            //self.input.addEventListener('change', () => {
            //    if (self.input.files.length > 0)
            //        self.uploadSingle(self.input.files[0], destination)
            //            .then(filename => resolve(filename))
            //            .catch(error => reject(error));
            //    else
            //        resolve('');
            //}, { once: true });
            window.addEventListener('focus', () => {
                setTimeout(() => {
                    if (self.input.files.length > 0)
                        self.uploadSingle(self.input.files[0], destination)
                            .then(filename => resolve(filename))
                            .catch(error => reject(error));
                    else
                        resolve('');
                }, 500);
            }, { once: true });
            self.input.click();
        })
    }

    getFileMulti(destination, callback) {

        this.input.multiple = true;
        const self = this;
        return new Promise((resolve, reject) => {
            window.addEventListener('focus', () => {
                setTimeout(() => {
                    if (self.input.files.length > 0)
                        self.uploadMulti(self.input.files, destination, callback)
                            .then(filename => resolve(filename))
                            .catch(error => reject(error));
                    else
                        resolve('');
                }, 500);
            }, { once: true });
            self.input.click();
        })
    }

    uploadSingle(file, destination) {
        const self = this;
        return new Promise((resolve, reject) => {
            try {

                let ext = self.getFileExtension(file.name);
                if (self.allowedFileTypes.indexOf(ext) == -1)
                    throw `I file con estensione ${ext} non possono essere caricati.`;

                if (file.size > self.maxLength)
                    throw `I file è troppo grande massima dimensione: ${self.maxLength} byte.`;

                var myHeaders = new Headers();
                myHeaders.append("Authorization", "Bearer " + Cookies.get('MB_AuthToken'));

                var formdata = new FormData();
                formdata.append("File", file);
                if (destination)
                    formdata.append("destination", destination);

                var requestOptions = {
                    method: 'POST',
                    headers: myHeaders,
                    body: formdata,
                    redirect: 'follow'
                };

                fetch(self.endPoint, requestOptions)
                    .then(response => response.json())
                    .then(result => {
                        if (result.success) {
                            resolve(result.data);
                        } else {
                            reject(result.msg);
                        }
                    })
                    .catch(error => reject(error));
            } catch (e) {
                reject(e);
            }
        })
    }

    uploadMulti(fileList, destination, callback) {
        const self = this;
        return new Promise((resolve, reject) => {
            self.uploadUtil(fileList, destination, 0, callback)
                .then(esito => resolve(esito))
                .catch(err => console.log(err));
        });
    }

    uploadUtil(filelist, destination, i, callback) {
        const self = this;
        return new Promise((resolve, reject) => {
            try {
                if (i == filelist.length)
                    resolve(i);
                else {
                    self.uploadSingle(filelist[i], destination)
                        .then(filename => {
                            if (typeof callback === 'function') {
                                callback(filename);
                            };
                            i++;
                            self.uploadUtil(filelist, destination, i, callback);
                        })
                        .catch(error => reject(error))
                }
            } catch (e) {
                reject(e);
            }
        })
    }

    getFileExtension(filename) {
        let i = filename.lastIndexOf('.');
        if (i == -1) return '';
        return filename.substr(i);
    }

}