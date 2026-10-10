// dock/js/api.js
const API = {
    runningText: {
        show() { window.socket?.send('runningtext.show'); },
        hide() { window.socket?.send('runningtext.hide'); },
        update(data) { window.socket?.send('runningtext.update', data); }
    },
    lowerThird: {
        show(data) { window.socket?.send('lowerthird.show', data); },
        hide() { window.socket?.send('lowerthird.hide'); }
    },
    scene: {
        list() { window.socket?.send('scene.list'); },
        switch(name) { window.socket?.send('scene.change', { scene: name }); }
    },
    ppt: {
        show() { window.socket?.send('ppt.show'); },
        hide() { window.socket?.send('ppt.hide'); },
        next() { window.socket?.send('ppt.next'); },
        previous() { window.socket?.send('ppt.previous'); }
    },
    emergency: {
        enable() { window.socket?.send('emergency.enable'); },
        disable() { window.socket?.send('emergency.disable'); }
    },
    theme: {
        change(name) { window.socket?.send('theme.change', { theme: name }); },
        list() { window.socket?.send('theme.list'); }
    },
    config: {
        save() { window.socket?.send('config.save'); },
        load() { window.socket?.send('config.load'); }
    }
};
