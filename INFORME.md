# Informe de práctica: Deployment y ReplicaSet con Grafana

## 1. Objetivo

Demostrar que un `Deployment` define el estado deseado, que el `ReplicaSet` mantiene el número de Pods demandado y que un `Service` ofrece acceso estable dentro del clúster. Como ejemplo se despliega Grafana.

## 2. Conceptos aplicados

- `Deployment`: administra la plantilla del Pod y permite escalar y actualizar la aplicación.
- `ReplicaSet`: mantiene el número deseado de Pods y reemplaza los que desaparecen.
- `Pod`: ejecuta el contenedor de Grafana.
- `Service`: expone la aplicación internamente con un punto estable de acceso.
- `kubectl port-forward`: permite acceder a la plataforma desde el equipo local a través de un túnel temporal.

## 3. Plataforma desplegada

Se utiliza Grafana, una plataforma de visualización y monitoreo. Puede integrarse con Prometheus, Loki y otros orígenes de datos para revisar métricas y logs.

## 4. Configuración

Ver los manifiestos:

- `k8s/namespace.yaml`
- `k8s/grafana.yaml`

El Deployment se define con una réplica inicial. El Service selecciona los Pods con la etiqueta `app: grafana` y ofrece el puerto 3000.

## 5. Despliegue

```bash
chmod +x scripts/*.sh
./scripts/deploy.sh
./scripts/verify.sh
```

## 6. Exposición local

```bash
kubectl -n observabilidad port-forward service/grafana 3000:3000
```

Abrir en el navegador: http://localhost:3000

## 7. Uso del ReplicaSet

Para verificar la autorrecuperación:

```bash
kubectl -n observabilidad get pods
kubectl -n observabilidad delete pod -l app=grafana
kubectl -n observabilidad get pods --watch
```

El ReplicaSet recrea el Pod para mantener el número deseado.

## 8. Escalado

```bash
kubectl -n observabilidad scale deployment/grafana --replicas=2
kubectl -n observabilidad get deployment,replicaset,pods
kubectl -n observabilidad scale deployment/grafana --replicas=1
```

## 9. Evidencias incluídas

Se adjuntan capturas demostrativas del proceso:

- [01-manifiestos en GitHub](evidencias/01-manifiestos.svg)
- [02-recursos de Kubernetes](evidencias/02-recursos-kubernetes.svg)
- [03-recreación del Pod](evidencias/03-recreacion-pod.svg)
- [04-Grafana en navegador](evidencias/04-grafana-navegador.svg)
- [05-escalado a 2 réplicas](evidencias/05-escalado.svg)

## 10. Conclusión

El ejemplo demuestra el funcionamiento básico del modelo declarativo de Kubernetes: el Deployment define la configuración deseada, el ReplicaSet restaura el número de Pods y el Service actúa como acceso interno estable. Grafana se utiliza como caso práctico de aplicación moderna en contenedores.
