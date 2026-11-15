# Grafana en Kubernetes: Deployment y ReplicaSet

Práctica para demostrar el despliegue de Grafana en Kubernetes mediante un `Deployment`, el `ReplicaSet` que este administra y un `Service` de tipo `ClusterIP`, con acceso local usando `kubectl port-forward`.

> **Importante sobre las evidencias:** los manifiestos y el informe están listos, pero las capturas auténticas requieren ejecutar la práctica en un clúster Kubernetes. No se incluyen imágenes simuladas. Sigue la sección [Evidencias](#evidencias-para-la-entrega) y agrega tus capturas reales a `evidencias/`.

## Requisitos

- Un clúster Kubernetes accesible (por ejemplo, Minikube, Docker Desktop Kubernetes, kind o un clúster del laboratorio).
- `kubectl` configurado para ese clúster.
- Navegador web.

## Archivos

- [`k8s/namespace.yaml`](k8s/namespace.yaml): namespace `observabilidad`.
- [`k8s/grafana.yaml`](k8s/grafana.yaml): Deployment y Service.
- [`scripts/deploy.sh`](scripts/deploy.sh): crea el namespace y el Secret localmente, y aplica los recursos.
- [`scripts/verify.sh`](scripts/verify.sh): consulta Deployment, ReplicaSet, Pods y Service.
- [`scripts/cleanup.sh`](scripts/cleanup.sh): elimina los recursos de la práctica.
- [`INFORME.md`](INFORME.md): informe listo para entregar, con procedimiento, conceptos, usos y checklist de evidencias.
- [`evidencias/README.md`](evidencias/README.md): instrucciones para capturar y guardar pruebas reales.

## Despliegue

Desde la raíz del repositorio:

```bash
chmod +x scripts/*.sh
./scripts/deploy.sh
```

El script solicita la contraseña del administrador de Grafana sin mostrarla en pantalla y crea un Secret en el clúster. La contraseña no se guarda en Git. También se puede hacer manualmente:

```bash
kubectl apply -f k8s/namespace.yaml
read -rsp 'Contraseña para Grafana: ' GRAFANA_ADMIN_PASSWORD; echo
kubectl -n observabilidad create secret generic grafana-admin \
  --from-literal=password="$GRAFANA_ADMIN_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -
unset GRAFANA_ADMIN_PASSWORD
kubectl apply -f k8s/grafana.yaml
```

Espera a que el despliegue esté disponible:

```bash
kubectl -n observabilidad rollout status deployment/grafana
```

## Comprobar Deployment y ReplicaSet

```bash
./scripts/verify.sh
kubectl -n observabilidad describe deployment grafana
```

El Deployment declara el estado deseado (una réplica) y administra un ReplicaSet. El ReplicaSet mantiene el número de Pods solicitado. Para observar la autorrecuperación, elimina el Pod actual y observa cómo se crea otro:

```bash
kubectl -n observabilidad get pods
kubectl -n observabilidad delete pod -l app=grafana
kubectl -n observabilidad get pods --watch
```

En otra terminal, ejecuta `Ctrl+C` para detener la observación. El Pod nuevo tendrá un nombre diferente.

Se puede demostrar el escalado temporal:

```bash
kubectl -n observabilidad scale deployment/grafana --replicas=2
kubectl -n observabilidad get deployment,replicaset,pods
kubectl -n observabilidad scale deployment/grafana --replicas=1
```

Grafana no comparte automáticamente entre varias réplicas su base de datos local ni todos los datos de sesión. El escalado aquí es solo una demostración del mecanismo de Kubernetes, no una recomendación de alta disponibilidad para Grafana.

## Exponer Grafana localmente

En una terminal, mantén activo el túnel:

```bash
kubectl -n observabilidad port-forward service/grafana 3000:3000
```

Visita <http://localhost:3000>. Usuario inicial: `admin`; contraseña: la que escribiste al ejecutar el script. Cambia la contraseña cuando Grafana lo solicite.

El Service es `ClusterIP`: solo es accesible dentro del clúster. `port-forward` crea un acceso temporal desde tu equipo; no publica Grafana en Internet.

## Usos de Grafana

Grafana permite consultar y visualizar métricas, logs y otros datos desde fuentes compatibles, por ejemplo Prometheus, Loki y bases de datos. Usos comunes:

- Crear paneles para supervisar aplicaciones, infraestructura y servicios.
- Revisar tendencias y comparar métricas en el tiempo.
- Configurar alertas sobre errores o valores que superen umbrales.
- Compartir visualizaciones entre equipos de operaciones y desarrollo.

El despliegue de esta práctica muestra la plataforma; conectar una fuente de datos es un paso posterior y no es necesario para verificar Deployment, ReplicaSet y Service.

## Limpieza

```bash
./scripts/cleanup.sh
```

## Evidencias para la entrega

Consulta [`evidencias/README.md`](evidencias/README.md) para capturar la configuración en GitHub, los recursos de Kubernetes, la recreación de un Pod y Grafana abierto en el navegador. Guarda las imágenes reales en `evidencias/` y súbelas al repositorio.

## Seguridad y alcance

El Secret de Kubernetes evita subir la contraseña al repositorio, pero los Secrets no sustituyen un gestor de secretos: por defecto, su valor se almacena codificado en Base64 y su protección depende también de la configuración del clúster y sus permisos. Usa una contraseña exclusiva para la práctica, no publiques credenciales y no expongas Grafana a Internet sin controles de seguridad adecuados.
