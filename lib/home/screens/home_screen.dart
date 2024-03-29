import 'package:chat_wave/chat/screens/chat_screen.dart';
import 'package:chat_wave/core/event/events_bloc/events_bloc.dart';
import 'package:chat_wave/home/blocs/channels_bloc/channels_bloc.dart';
import 'package:chat_wave/home/screens/share_screen.dart';
import 'package:chat_wave/setting/screen/settings_screen.dart';
import 'package:chat_wave/utils/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/connect_bloc/connect_bloc.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late final TextEditingController _searchFieldController;

  @override
  void initState() {
    _searchFieldController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
    // initialize events bloc
    BlocProvider.of<EventsBloc>(context).add(Initialize());
    super.initState();
  }

  @override
  void dispose() {
    _searchFieldController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        BlocProvider.of<EventsBloc>(context).add(Resume());
        break;
      case AppLifecycleState.paused:
        BlocProvider.of<EventsBloc>(context).add(Pause());
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConnectBloc(),
      child: Scaffold(
        body: SafeArea(
          child: BlocListener<ConnectivityBloc, ConnectivityState>(
            listener: (ctx, state) {
              if (state is! ConnectivityStatus) return;
              if (!state.connected) {
                const dissconnectedSnackback = SnackBar(
                  content: Text('No Internet Connection'),
                  backgroundColor: Colors.red,
                  duration: Duration(days: 30),
                );
                ScaffoldMessenger.of(ctx).showSnackBar(dissconnectedSnackback);
              } else {
                ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
              }
            },
            child: Column(
              children: [
                BlocConsumer<ConnectBloc, ConnectState>(
                  listener: (ctx, state) {
                    // TODO: implement listener
                  },
                  builder: (ctx, state) {
                    return HomeTop(
                      onAddClick: () =>
                          BlocProvider.of<ConnectBloc>(ctx).add(ScanSecret()),
                      onShareClick: () =>
                          Navigator.of(context).push(ShareScreen.route),
                      onSettingsClick: () {
                        Navigator.of(context).push(SettingsScreen.route);
                      },
                    );
                  },
                ),
                const SizedBox(height: 18),
                _searchField(context),
                const SizedBox(height: 4.0),
                Expanded(
                  child: BlocProvider(
                    create: (_) => ChannelsBloc(),
                    child: BlocBuilder<ChannelsBloc, ChannelsState>(
                      builder: (ctx, state) {
                        final channels = (state as ChannelsList).channels;
                        return ListView.builder(
                          itemCount: channels.length,
                          itemBuilder: (_, index) {
                            return ChatItem(
                              channel: channels[index],
                              onClick: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChatScreen(channel: channels[index]),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        controller: _searchFieldController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search for chat or messages',
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }
}
