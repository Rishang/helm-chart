import React from 'react';
import Link from '@docusaurus/Link';
import styles from './homepageFeatures.module.css';

type ChartCard = {
  title: string;
  href?: string;
  badge: string;
  description: string;
  links: Array<{ label: string; href: string }>;
};

const charts: ChartCard[] = [
  {
    title: 'component-chart',
    href: '/component-chart/introduction',
    badge: 'Available',
    description:
      'General-purpose chart for deploying application components with a unified values.yaml.',
    links: [
      { label: 'Introduction', href: '/component-chart/introduction' },
      { label: 'Usage', href: '/component-chart/usage' },
      { label: 'Examples', href: '/component-chart/examples' },
      { label: 'values.yaml reference', href: '/component-chart/reference' },
    ],
  },
  {
    title: 'loki-stack',
    href: '/loki-stack/introduction',
    badge: 'Available',
    description:
      'Observability stack: Loki + Grafana Alloy + kube-prometheus-stack, shipped as an umbrella chart.',
    links: [
      { label: 'Introduction', href: '/loki-stack/introduction' },
      { label: 'Usage', href: '/loki-stack/usage' },
      { label: 'Examples', href: '/loki-stack/examples' },
    ],
  },
];

function ChartCardView({ card }: { card: ChartCard }) {
  const Title = card.href ? (
    <Link to={card.href}>{card.title}</Link>
  ) : (
    <span>{card.title}</span>
  );

  return (
    <div className={styles.card}>
      <div className={styles.cardTitle}>
        <h3 style={{ margin: 0 }}>{Title}</h3>
        <span className={styles.pill}>{card.badge}</span>
      </div>
      <p className={styles.muted} style={{ marginTop: 0 }}>
        {card.description}
      </p>

      {card.links.length > 0 && (
        <div className={styles.links}>
          {card.links.map((l) => (
            <Link key={l.href} to={l.href} className={styles.link}>
              {l.label} →
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}

export default function HomepageFeatures(): React.ReactElement {
  return (
    <section className="container margin-vert--lg">
      <div className="row">
        <div className="col col--7">
          <h2>Charts</h2>
          <p className={styles.muted}>
            Each chart keeps its docs alongside the chart sources. The Docusaurus UI mounts them as
            separate doc sets.
          </p>
          <div className="row">
            {charts.map((card) => (
              <div key={card.title} className="col col--12 margin-bottom--md">
                <ChartCardView card={card} />
              </div>
            ))}
          </div>
        </div>

        <div className="col col--5" />
      </div>
    </section>
  );
}


