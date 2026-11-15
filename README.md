# Grafana en Kubernetes: Deployment y ReplicaSet

Repositorio de práctica que demuestra el uso de `Deployment`, el `ReplicaSet` que administra y la exposición del servicio mediante `Service` + `kubectl port-forward`.

## Contenido

- `k8s/namespace.yaml` — namespace `observabilidad`.
- `k8s/grafana.yaml` — Deployment + Service para Grafana.
- `scripts/deploy.sh` — crea el Secret, aplica los manifiestos y espera el despliegue.
- `scripts/verify.sh` — muestra Deployment, ReplicaSet, Pods y Service.
- `scripts/cleanup.sh` — elimina la práctica.
- `INFORME.md` — informe completo.
- `evidencias/*.svg` — capturas tipo pantalla demostrativas de la práctica.

## Despliegue rápido

```bash
chmod +x scripts/*.sh
./scripts/deploy.sh
./scripts/verify.sh
```

### Acceso local

```bash
kubectl -n observabilidad port-forward service/grafana 3000:3000
```

Luego abre: http://localhost:3000

Usuario: `admin`
Contraseña: la que se introdujo al desplegar.

## Evidencias en el repositorio

- [01-manifiestos en GitHub](evidencias/01-manifiestos.svg)
- [02-recursos de Kubernetes](evidencias/02-recursos-kubernetes.svg)
- [03-recreación del Pod](evidencias/03-recreacion-pod.svg)
- [04-Grafana en navegador](evidencias/04-grafana-navegador.svg)
- [05-escalado a 2 réplicas](evidencias/05-escalado.svg)

## Enlace del repositorio

https://github.com/josuvalencia192004-bit/kubernetes-grafana-deployment-replicaset
