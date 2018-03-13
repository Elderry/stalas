// Future versions of Hyper may add additional config options,
// which will not automatically be merged into this file.
// See https://hyper.is#cfg for all currently supported options.

module.exports = {
  config: {
    // Choose either "stable" for receiving highly polished,
    // or "canary" for less polished but more frequent updates
    updateChannel: 'canary',

    // default font size in pixels for all tabs
    fontSize: 18,

    // font family with optional fallbacks
    fontFamily: 'Sarasa Mono SC',

    // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
    cursorColor: 'rgba(248,28,229,1)',

    // `BEAM` for |, `UNDERLINE` for _, `BLOCK` for █
    cursorShape: 'BEAM',

    // set to true for blinking cursor
    cursorBlink: true,

    // color of the text
    foregroundColor: '#0c0c0c',

    // terminal background color
    backgroundColor: '#f2f2f2',

    // border color (window, tabs)
    borderColor: '#f2f2f2',

    // custom css to embed in the main window
    css: '',

    // custom css to embed in the terminal window
    termCSS: `
        .tab_textActive { color: blue; background: #f2f2f2; }
        .tab_tab { background: gray; }
        .header_windowHeader { background: darkMagenta; }
    `,

    // set to `true` (without backticks) if you're using a Linux setup that doesn't show native menus
    // default: `false` on Linux, `true` on Windows (ignored on macOS)
    showHamburgerMenu: 'true',

    // set to `false` if you want to hide the minimize, maximize and close buttons
    // additionally, set to `'left'` if you want them on the left, like in Ubuntu
    // default: `true` on windows and Linux (ignored on macOS)
    showWindowControls: 'true',

    // custom padding (css format, i.e.: `top right bottom left`)
    padding: '12px 12px',

    // the full list. if you're going to provide the full color palette,
    // including the 6 x 6 color cubes and the grayscale map, just provide
    // an array here instead of a color map object
    colors: {
      black: '#0c0c0c',
      red: '#c50f1f',
      green: '#13a10e',
      yellow: '#c19c00',
      blue: '#0037da',
      magenta: '#881798',
      cyan: '#3a96dd',
      white: '#cccccc',
      lightBlack: '#767676',
      lightRed: '#e74856',
      lightGreen: '#16c60c',
      lightYellow: '#b5ba00',
      lightBlue: '#3b78ff',
      lightMagenta: '#b4009e',
      lightCyan: '#61d6d6',
      lightWhite: '#f2f2f2'
    },

    // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
    // if left empty, your system's login shell will be used by default
    //
    // Windows
    // - Make sure to use a full path if the binary name doesn't work
    // - Remove `--login` in shellArgs
    //
    // Bash on Windows
    // - Example: `C:\\Windows\\System32\\bash.exe`
    //
    // Powershell on Windows
    // - Example: `C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe`
    shell: 'C:\\Program Files\\PowerShell\\6.0.1\\pwsh.exe',
    // shell: 'C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe',

    // for setting shell arguments (i.e. for using interactive shellArgs: ['-i'])
    // by default ['--login'] will be used
    shellArgs: [],

    // for environment variables
    env: {},

    // set to false for no bell
    bell: 'SOUND',

    // if true, selected text will automatically be copied to the clipboard
    copyOnSelect: false,

    // if true, on right click selected text will be copied or pasted if no
    // selection is present (true by default on Windows)
    // quickEdit: true

    // URL to custom bell
    // bellSoundURL: 'http://example.com/bell.mp3',

    // for advanced config flags please refer to https://hyper.is/#cfg
    windowSize: [1000, 600]
  },

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: [],

  // in development, you can create a directory under
  // `~/.hyper_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: [],

  keymaps: {
    // Example
    // 'window:devtools': 'cmd+alt+o',
  }
};
