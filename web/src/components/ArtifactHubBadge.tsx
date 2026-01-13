import React from 'react';

type ArtifactHubBadgeProps = {
  /** Chart/package name (e.g. "loki-stack") */
  name: string;
  /** Artifact Hub repository/namespace (e.g. "helm-charts"). */
  repo?: string;
};

export default function ArtifactHubBadge({
  name,
  repo = 'common-charts',
}: ArtifactHubBadgeProps) {
  const artifactHubPackageUrl = `https://artifacthub.io/packages/helm/${repo}/${name}`;
  // Repository-level Artifact Hub badge via Shields.io endpoint.
  const badgeUrl = `https://img.shields.io/endpoint?url=${encodeURIComponent(
    `https://artifacthub.io/badge/repository/${repo}`,
  )}`;

  return (
    <a href={artifactHubPackageUrl} target="_blank" rel="noreferrer">
      <img
        src={badgeUrl}
        alt="Artifact Hub"
        style={{ height: 18, verticalAlign: 'middle' }}
      />
    <br />
    </a>
  );
}
