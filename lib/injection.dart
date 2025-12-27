import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:geolocator/geolocator.dart';

import 'core/network/network_info.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/client_remote_datasource.dart';
import 'data/datasources/interaction_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/client_repository_impl.dart';
import 'data/repositories/interaction_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/client_repository.dart';
import 'domain/repositories/interaction_repository.dart';
import 'domain/usecases/auth/sign_in_usecase.dart';
import 'domain/usecases/auth/sign_up_usecase.dart';
import 'domain/usecases/auth/sign_out_usecase.dart';
import 'domain/usecases/auth/get_current_user_usecase.dart';
import 'domain/usecases/client/get_client_list_usecase.dart';
import 'domain/usecases/client/add_client_usecase.dart';
import 'domain/usecases/client/update_client_usecase.dart';
import 'domain/usecases/client/delete_client_usecase.dart';
import 'domain/usecases/client/search_clients_usecase.dart';
import 'domain/usecases/interaction/get_interaction_list_usecase.dart';
import 'domain/usecases/interaction/add_interaction_usecase.dart';
import 'domain/usecases/interaction/update_interaction_usecase.dart';
import 'domain/usecases/interaction/delete_interaction_usecase.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/client_provider.dart';
import 'presentation/providers/interaction_provider.dart';

// Remove this problematic import
// import 'package:firebase_auth_platform_interface/src/auth_provider.dart' as firebase_auth_platform;

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => GeolocatorPlatform.instance);
  
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      auth: sl(),
      firestore: sl(),
    ),
  );
  
  sl.registerLazySingleton<ClientRemoteDataSource>(
    () => ClientRemoteDataSourceImpl(
      firestore: sl(),
    ),
  );
  
  sl.registerLazySingleton<InteractionRemoteDataSource>(
    () => InteractionRemoteDataSourceImpl(
      firestore: sl(),
    ),
  );
  
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  
  sl.registerLazySingleton<ClientRepository>(
    () => ClientRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  
  sl.registerLazySingleton<InteractionRepository>(
    () => InteractionRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  
  // Use cases
  // Auth
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  
  // Client
  sl.registerLazySingleton(() => GetClientListUseCase(sl()));
  sl.registerLazySingleton(() => AddClientUseCase(sl()));
  sl.registerLazySingleton(() => UpdateClientUseCase(sl()));
  sl.registerLazySingleton(() => DeleteClientUseCase(sl()));
  sl.registerLazySingleton(() => SearchClientsUseCase(sl()));
  
  // Interaction
  sl.registerLazySingleton(() => GetInteractionListUseCase(sl()));
  sl.registerLazySingleton(() => AddInteractionUseCase(sl()));
  sl.registerLazySingleton(() => UpdateInteractionUseCase(sl()));
  sl.registerLazySingleton(() => DeleteInteractionUseCase(sl()));
  
  // Providers - FIX THE AUTH PROVIDER REGISTRATION
  sl.registerFactory(() => AuthProvider(
    signInUseCase: sl(),
    signUpUseCase: sl(),
    signOutUseCase: sl(),
    getCurrentUserUseCase: sl(),
  ));
  
  sl.registerFactory(() => ClientProvider(
    getClientListUseCase: sl(),
    addClientUseCase: sl(),
    updateClientUseCase: sl(),
    deleteClientUseCase: sl(),
    searchClientsUseCase: sl(),
  ));
  
  sl.registerFactory(() => InteractionProvider(
    getInteractionListUseCase: sl(),
    addInteractionUseCase: sl(),
    updateInteractionUseCase: sl(),
    deleteInteractionUseCase: sl(),
  ));
}