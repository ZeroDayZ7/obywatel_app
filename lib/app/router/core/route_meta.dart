class RouteMeta {
  final String title;

  const RouteMeta({required this.title});
}

class RouteNames {
  static const home = 'home';

  static const work = 'work';
  static const workJobOffers = 'workJobOffers';
  static const workMyCV = 'workMyCV';
  static const workApplications = 'workApplications';
  static const workCareerAdvice = 'workCareerAdvice';
  static const workInternships = 'workInternships';
  static const workGovernmentSupport = 'workGovernmentSupport';
  static const workEmploymentMap = 'workEmploymentMap';
}

final routeMetaMap = {
  RouteNames.home: RouteMeta(title: 'Strona główna'),

  RouteNames.work: RouteMeta(title: 'Praca i Kariera'),
  RouteNames.workJobOffers: RouteMeta(title: 'Oferty pracy'),
  RouteNames.workMyCV: RouteMeta(title: 'Mój Kreator CV'),
  RouteNames.workApplications: RouteMeta(title: 'Moje aplikacje'),
  RouteNames.workCareerAdvice: RouteMeta(title: 'Porady zawodowe'),
  RouteNames.workInternships: RouteMeta(title: 'Staże i praktyki'),
  RouteNames.workGovernmentSupport: RouteMeta(title: 'Wsparcie publiczne'),
  RouteNames.workEmploymentMap: RouteMeta(title: 'Mapa zatrudnienia'),
};
