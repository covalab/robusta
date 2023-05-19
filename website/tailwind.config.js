// tailwind.config.js
/** @type {import('tailwindcss').Config} */
module.exports = {
    corePlugins: {
      preflight: false, // disable Tailwind's reset
    },
    content: ["./src/**/*.{js,jsx,ts,tsx}", "../docs/**/*.mdx"], // my markdown stuff is in ../docs, not /src
    darkMode: ['class', '[data-theme="dark"]'], // hooks into docusaurus' dark mode settigns
    theme: {
      extend: {
        colors: {
            primary: {
                100: '#906548', 
                200: '#805a3f',
                300: '#7a563d',
                400: '#6f4e37',
                500: '#644631', 
                600: '#5e422f', 
                700: '#4e3726',
            }, 
            lightPrimary: {
                100: '#c3f3f2',
                200: '#99eae9',
                300: '#8be8e6',
                400: '#6fe2e0',
                500: '#53dcda',
                600: '#45dad7',
                700: '#28c4c2'
            }
           
        }
      },
    },
    plugins: [],
  }