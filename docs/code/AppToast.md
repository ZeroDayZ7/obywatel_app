- 1️⃣ z kontekstem (np. w ekranie)

```
AppToast.show(context, message: 'Zapisano zmiany', type: ToastType.success);
```

- 2️⃣ globalnie (np. w serwisie / providerze)

```
AppToast.showGlobal('Sesja wygasła, zaloguj się ponownie', type: ToastType.error);
```
