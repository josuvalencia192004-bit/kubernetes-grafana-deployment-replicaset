# Evidencias de la ejecución

Guarda aquí capturas auténticas generadas al ejecutar la práctica. Las capturas del clúster y del navegador no pueden generarse desde el repositorio; requieren un clúster activo en tu equipo o laboratorio. No incluyas contraseñas, tokens ni otros datos sensibles.

Nombres sugeridos:

1. `01-manifiestos-github.png` — manifiestos de configuración visibles en el repositorio.
2. `02-recursos-kubernetes.png` — `kubectl -n observabilidad get deployment,replicaset,pods,service`.
3. `03-recreacion-pod.png` — demostración de eliminación y recreación del Pod.
4. `04-grafana-navegador.png` — Grafana abierto en `http://localhost:3000`, sin credenciales visibles.
5. `05-escalado.png` — opcional, dos réplicas y vuelta a una.

Comandos útiles:

```bash
./scripts/verify.sh
kubectl -n observabilidad describe deployment grafana
kubectl -n observabilidad delete pod -l app=grafana
kubectl -n observabilidad get pods --watch
kubectl -n observabilidad scale deployment grafana --replicas=2
kubectl -n observabilidad get deployment,replicaset,pods
kubectl -n observabilidad scale deployment grafana --replicas=1
kubectl -n observabilidad port-forward service/grafana 3000:3000
```

Para agregar tus imágenes al repositorio: guarda los PNG con los nombres sugeridos en esta carpeta y haz commit/push. Luego enlázalas en `INFORME.md` usando, por ejemplo, `![Recursos de Kubernetes](evidencias/02-recursos-kubernetes.png)`.
