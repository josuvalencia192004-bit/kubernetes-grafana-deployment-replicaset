# Informe: despliegue de Grafana con Deployment y ReplicaSet

**Estudiante:** ______________________________  
**Asignatura / sección:** ______________________________  
**Fecha:** ______________________________  
**Repositorio público:** https://github.com/josuvalencia192004-bit/kubernetes-grafana-deployment-replicaset

> Completa tus datos y agrega las capturas auténticas indicadas en `evidencias/README.md` antes de entregar. Las capturas deben obtenerse ejecutando el manifiesto en tu clúster; no se han inventado ni simulado.

## 1. Objetivo

Desplegar Grafana en Kubernetes y demostrar cómo un `Deployment` administra un `ReplicaSet`, cómo este mantiene la cantidad deseada de Pods y cómo exponer la aplicación mediante un Service y acceso local temporal.

## 2. Plataforma y usos

Grafana es una plataforma para explorar y visualizar datos de fuentes compatibles, como Prometheus, Loki y bases de datos. Puede utilizarse para crear paneles de monitoreo, analizar tendencias, centralizar métricas y configurar alertas.

En esta práctica se despliega Grafana para demostrar recursos de Kubernetes. No se configura una fuente de datos externa.

## 3. Conceptos aplicados

- **Deployment:** declara el estado deseado de la aplicación y facilita actualizaciones y cambios de escala. En este ejercicio solicita una réplica.
- **ReplicaSet:** es creado y administrado por el Deployment. Mantiene el número de Pods que corresponde a la plantilla y reemplaza los Pods que desaparecen.
- **Pod:** unidad que ejecuta el contenedor `grafana/grafana:11.2.0`, expuesto internamente en el puerto TCP 3000.
- **Service `ClusterIP`:** selecciona el Pod por la etiqueta `app: grafana` y ofrece un punto de acceso estable en el puerto 3000 dentro del clúster.
- **`kubectl port-forward`:** establece un túnel local al Service para abrir Grafana en el navegador sin publicar el servicio en Internet.
- **Sondas:** `readinessProbe` indica cuándo el contenedor está listo para recibir tráfico; `livenessProbe` permite detectar un contenedor que no responde correctamente.
- **Secret:** entrega la contraseña inicial al contenedor sin escribirla en los archivos versionados del repositorio.

## 4. Configuración y procedimiento

Los manifiestos están en [`k8s/namespace.yaml`](k8s/namespace.yaml) y [`k8s/grafana.yaml`](k8s/grafana.yaml). El segundo declara el Deployment y el Service. El script [`scripts/deploy.sh`](scripts/deploy.sh) crea el namespace, solicita una contraseña local, genera/actualiza el Secret en el clúster y aplica el manifiesto.

Requisitos: un clúster Kubernetes activo, `kubectl` configurado y un navegador.

```bash
chmod +x scripts/*.sh
./scripts/deploy.sh
./scripts/verify.sh
```

Para observar la autorrecuperación, elimina el Pod y vuelve a listar los recursos:

```bash
kubectl -n observabilidad get pods
kubectl -n observabilidad delete pod -l app=grafana
kubectl -n observabilidad get pods --watch
```

Para demostrar escalado temporal, ejecuta:

```bash
kubectl -n observabilidad scale deployment/grafana --replicas=2
kubectl -n observabilidad get deployment,replicaset,pods
kubectl -n observabilidad scale deployment/grafana --replicas=1
```

El escalado se usa como demostración de Kubernetes; Grafana no comparte automáticamente en varias réplicas su almacenamiento local y sesiones, así que este manifiesto no configura alta disponibilidad.

## 5. Exposición de la plataforma

Se utiliza `ClusterIP`, que no expone el servicio fuera del clúster. Para acceder desde el equipo local, se deja ejecutando:

```bash
kubectl -n observabilidad port-forward service/grafana 3000:3000
```

Después se abre <http://localhost:3000> y se inicia sesión con el usuario `admin` y la contraseña introducida durante el despliegue. Cambia la contraseña al iniciar sesión. El port-forward es temporal y no equivale a publicar el servicio en Internet.

## 6. Resultados y análisis

Al aplicar el Deployment, Kubernetes crea el ReplicaSet y este crea el Pod solicitado. Al eliminar el Pod, el ReplicaSet observa que hay menos Pods de los deseados y crea otro a partir de la plantilla del Deployment. Al cambiar las réplicas a dos, el estado observado debe mostrar dos Pods; al volver a una, debe quedar uno.

Completa tras ejecutar la práctica:

- Clúster utilizado: ______________________________
- Pods observados antes de eliminar uno: ______________________________
- Nombre/estado del Pod recreado: ______________________________
- Resultado del escalado temporal: ______________________________
- Acceso a Grafana por `localhost:3000`: Sí / No

## 7. Evidencias (capturas pendientes de ejecución)

Inserta en esta sección las capturas reales guardadas en [`evidencias/`](evidencias/README.md):

1. Manifiestos `k8s/grafana.yaml` visibles en el repositorio.
2. Salida de `kubectl get deployment,replicaset,pods,service -n observabilidad`.
3. Pod eliminado y Pod nuevo en ejecución (salida antes/después o seguimiento).
4. Grafana cargado en el navegador en `http://localhost:3000` (no mostrar la contraseña).
5. Opcional: escalado a dos réplicas y regreso a una.

## 8. Conclusión

La práctica demuestra que el Deployment administra el ciclo de vida de la aplicación y el ReplicaSet mantiene la cantidad declarada de Pods, incluso después de eliminar uno. El Service brinda un nombre y puerto estable dentro del clúster, y `port-forward` permite comprobar la interfaz desde el equipo local sin realizar una exposición pública.

## 9. Seguridad

No se almacena ninguna contraseña en los manifiestos ni debe subirse al repositorio. Los Secrets de Kubernetes usan codificación Base64, que no es cifrado por sí misma; la protección depende de los controles y la configuración del clúster. Se debe usar una contraseña exclusiva y no exponer Grafana públicamente sin autenticación y controles de red adecuados.
