// @ts-check

const {themes: prismThemes} = require('prism-react-renderer');
const lightCodeTheme = prismThemes.github;
const darkCodeTheme = prismThemes.dracula;

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'common-chart',
  tagline: 'Helm chart documentation',
  favicon: 'img/favicon.ico',

  url: 'https://rishang.github.io',
  baseUrl: '/common-chart/',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  organizationName: 'rishang',
  projectName: 'common-chart',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: false,
        blog: false,
        pages: {},
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],

  plugins: [
    [
      '@docusaurus/plugin-content-docs',
      {
        id: 'component-chart',
        // Use the chart docs directly, so chart + docs stay together
        path: '../helm/component-chart/docs/pages',
        routeBasePath: 'component-chart',
        sidebarPath: require.resolve('./sidebars/component-chart.js'),
        showLastUpdateAuthor: false,
        showLastUpdateTime: false,
      },
    ],

    [
      '@docusaurus/plugin-content-docs',
      {
        id: 'loki-stack',
        // Use the chart docs directly, so chart + docs stay together
        path: '../helm/loki-stack/docs/pages',
        routeBasePath: 'loki-stack',
        sidebarPath: require.resolve('./sidebars/loki-stack.js'),
        showLastUpdateAuthor: false,
        showLastUpdateTime: false,
      },
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      colorMode: {
        defaultMode: 'dark',
        disableSwitch: true,
        respectPrefersColorScheme: false,
      },
      navbar: {
        title: 'common-chart',
        items: [
          {
            type: 'docSidebar',
            sidebarId: 'componentChartSidebar',
            docsPluginId: 'component-chart',
            position: 'left',
            label: 'component-chart',
          },
          {
            type: 'docSidebar',
            sidebarId: 'lokiStackSidebar',
            docsPluginId: 'loki-stack',
            position: 'left',
            label: 'loki-stack',
          },
          // {
          //   href: 'https://github.com/Rishang/common-chart/stargazers',
          //   position: 'right',
          //   className: 'header-github-star',
          //   'aria-label': 'Star on GitHub',
          // },
          {
            href: 'https://github.com/Rishang/common-chart',
            position: 'right',
            className: 'header-github-link',
            'aria-label': 'GitHub repository',
          },
        ],
      },
      footer: {
        style: 'dark',
        // copyright: ``,
        links: [
          {
            title: 'Community',
            items: [
              {
                label: 'GitHub',
                href: 'https://github.com/Rishang/common-chart',
              },
            ],
          },
        ],
      },
      prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
        additionalLanguages: ['yaml'],
      },
    }),
};

module.exports = config;


