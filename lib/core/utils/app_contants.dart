import 'package:responsive_framework/responsive_framework.dart';

List<Breakpoint> listBreakPoint = [
  const Breakpoint(start: 0, end: 350, name: MOBILE),
  const Breakpoint(start: 351, end: 600, name: TABLET),
  const Breakpoint(start: 601, end: 800, name: DESKTOP),
  const Breakpoint(start: 801, end: 1700, name: 'XL'),
  const Breakpoint(start: 1701, end: 2000, name: 'XXL'),
  const Breakpoint(start: 2001, end: 3000, name: 'XXXL'),
];

const String active = 'Activo';
const String inactive = "Inactivo";
