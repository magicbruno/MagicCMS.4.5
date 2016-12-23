/*=================================================
    Mb_history
    Semplice gestione di una history di stati
    uso: var theHistory = new Mb_history(home)
    Done home è l'oggetto che rappresenta lo stato 
    iniziale
===================================================*/

var Mb_history = function (options) {
    var opt = options || {};
    opt.action = opt.action || this.DEFAULT.action;
    opt.home = opt.home || this.DEFAULT.home;
    this.init(opt);
}
Mb_history.DEFALTS = {
    action: function () { },
    home: {}
}

Mb_history.prototype = {
    init: function (options) {
        this.history = [];
        if (typeof options.action == 'function') {
            this.action = options.action;
        }
        this.home = options.home;
        this.current = -1;
        var saved = options.loadsaved;
        if (saved)
            this.load(saved)
        else
            this.gohome();
    },
    goto: function (obj) {
        this.history = this.history.slice(0, this.current + 1);
        this.history.push(obj);
        this.current = this.history.length - 1;
        this.action(this.history[this.current], this.current, this.history.length);
    },
    back: function () {
        if (this.current > 0) {
            this.current -= 1;
            this.action(this.history[this.current], this.current, this.history.length);
        }
    },
    forward: function () {
        if (this.current < this.history.length - 1) {
            this.current += 1;
            this.action(this.history[this.current], this.current, this.history.length);
        }
    },
    gohome: function () {
        //if (this.current != 0) {
        //    this.current = 0;
        //    this.action(this.history[this.current], this.current, this.history.length);
        //}
        this.goto(this.home);
    },
    reload: function () {
        this.action(this.history[this.current], this.current, this.history.length);
    },
    action: function () {
    },
    getCurrent: function () {
        return this.history[this.current];
    },
    setCurrent: function (val) {
        this.history[this.current] = val;
    },
    load: function (id) {
        var name = id || 'mb-history';
        if (typeof Storage !== "undefined") {
            var temp = localStorage.getItem(name) || '{}';
            saved = JSON.parse(temp);
            this.history = saved.history || [this.home];
            this.current = saved.current || 0;
            this.reload();
        }
    },
    save: function (id) {
        var name = id || 'mb-history';
        if (typeof Storage !== "undefined") {
            var saved = {};
            saved.history = this.history;
            saved.current = this.current;
            localStorage.setItem(id, JSON.stringify(saved));
        }
    },
    history: [],
    current: 0,
    home:{}
}
