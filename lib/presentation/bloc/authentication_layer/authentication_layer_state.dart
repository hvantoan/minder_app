part of 'authentication_layer_cubit.dart';

abstract class AuthenticationLayerState {}

class AuthenticationLayerInitialState extends AuthenticationLayerState {}

class UnauthenticatedState extends AuthenticationLayerState {}

class AuthenticatedState extends AuthenticationLayerState {}
