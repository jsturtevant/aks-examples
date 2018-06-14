1. Use the [development version of jaeger](https://github.com/jaegertracing/jaeger-kubernetes#production-setup) to get up and running fast

```
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-kubernetes/master/all-in-one/jaeger-all-in-one-template.yml
```

2. Run the hot rod example

```
kubectl apply -f hotrod.yaml
```

3. Get services and view sites

```
kubectl get svc

NAME               TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                        AGE
hotrod             LoadBalancer   10.0.119.192   104.211.53.248   80:30294/TCP                   25m
jaeger-agent       ClusterIP      None           <none>           5775/UDP,6831/UDP,6832/UDP     1h
jaeger-collector   ClusterIP      10.0.42.206    <none>           14267/TCP,14268/TCP,9411/TCP   1h
jaeger-query       LoadBalancer   10.0.75.227    40.121.41.240    80:30683/TCP                   1h
```

Find the service ip for hotrod and jaeger-query.  Click on the hotrod UI a few times and then explorer in jaeger.  A walk through of the code and process can be found at https://medium.com/opentracing/take-opentracing-for-a-hotrod-ride-f6e3141f7941.  Have fun!

> note: this does not demonstrate how to run in production.  See https://github.com/jaegertracing/jaeger-kubernetes#production-setup for guidance