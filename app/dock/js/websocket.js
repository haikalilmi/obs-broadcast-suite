// dock/js/websocket.js
class BroadcastSocket {
    constructor(url = 'ws://127.0.0.1:4456') {
        this.url = url;
        this.ws = null;
        this.listeners = {};
        this.connect();
    }

    connect() {
        try {
            this.ws = new WebSocket(this.url);
        } catch(e) {
            console.warn('WebSocket connection failed');
            setTimeout(() => this.connect(), 3000);
            return;
        }

        this.ws.onopen = () => {
            console.log('Connected to Lua Backend');
            this.emit('connection', { status: 'connected' });
        };

        this.ws.onclose = () => {
            console.log('Disconnected, reconnecting...');
            this.emit('connection', { status: 'disconnected' });
            setTimeout(() => this.connect(), 3000);
        };

        this.ws.onerror = () => {
            this.ws.close();
        };

        this.ws.onmessage = (e) => {
            try {
                const msg = JSON.parse(e.data);
                if (msg.event && this.listeners[msg.event]) {
                    this.listeners[msg.event].forEach(cb => cb(msg.data));
                }
                if (this.listeners['*']) {
                    this.listeners['*'].forEach(cb => cb(msg));
                }
            } catch(err) {
                console.error('Invalid WebSocket message');
            }
        };
    }

    send(event, data = {}) {
        if (this.ws && this.ws.readyState === WebSocket.OPEN) {
            this.ws.send(JSON.stringify({
                event: event,
                data: data,
                timestamp: Date.now()
            }));
        }
    }

    emit(event, data) {
        if (this.listeners[event]) this.listeners[event].forEach(cb => cb(data));
    }

    on(event, callback) {
        if (!this.listeners[event]) this.listeners[event] = [];
        this.listeners[event].push(callback);
    }

    off(event, callback) {
        if (!this.listeners[event]) return;
        this.listeners[event] = this.listeners[event].filter(cb => cb !== callback);
    }
}
