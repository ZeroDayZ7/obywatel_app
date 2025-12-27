enum AppInitStatus {
  loading, // Trwa bootstrap (kroki asynchroniczne)
  unauthenticated, // Brak sesji -> idź do /login
  locked, // Sesja jest, ale wymagany PIN -> idź do /pin
  authorized, // Wszystko OK -> idź do /home
  forceUpdate, // Wymagana aktualizacja -> idź do /update
}
