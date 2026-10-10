// dock/js/theme.js
const ThemeManager = {
    current: 'modern',
    themes: {
        modern: {
            primary: '#0078d4',
            background: '#1e1e1e',
            surface: '#2d2d2d',
            text: '#e1e1e1',
            border: '#3e3e3e',
            danger: '#d13438',
            success: '#4caf50',
            warning: '#ff9800'
        },
        minimal: {
            primary: '#607d8b',
            background: '#212121',
            surface: '#333333',
            text: '#ffffff',
            border: '#424242',
            danger: '#e53935',
            success: '#66bb6a',
            warning: '#ffa726'
        },
        flat: {
            primary: '#2980b9',
            background: '#2c3e50',
            surface: '#34495e',
            text: '#ecf0f1',
            border: '#7f8c8d',
            danger: '#e74c3c',
            success: '#27ae60',
            warning: '#f39c12'
        },
        islamic: {
            primary: '#2e7d32',
            background: '#1b1b1b',
            surface: '#2a2a2a',
            text: '#f0e6d3',
            border: '#4a4a4a',
            danger: '#c62828',
            success: '#388e3c',
            warning: '#ef6c00'
        }
    },

    apply(name) {
        if (!this.themes[name]) name = 'modern';
        this.current = name;
        const theme = this.themes[name];
        const root = document.documentElement;
        for (const [key, value] of Object.entries(theme)) {
            root.style.setProperty('--' + key, value);
        }
    },

    load() {
        const saved = localStorage.getItem('obs-theme');
        this.apply(saved || 'modern');
    }
};
