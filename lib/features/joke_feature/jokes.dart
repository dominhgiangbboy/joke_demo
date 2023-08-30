import 'package:flutter/material.dart';

import 'package:demo_for_vnext/core/enum.dart';
import 'package:demo_for_vnext/core/type_def.dart';
import 'package:demo_for_vnext/features/joke_feature/blocs/joke_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JokesPage extends StatefulWidget {
  const JokesPage({
    Key? key,
    required this.bloc,
  }) : super(key: key);
  final JokeBloc bloc;

  @override
  State<JokesPage> createState() => _JokesPageState();
}

const String appTitle = 'Jokes Finder';
const String errorMessage = 'Error fetching jokes';
const String submitSuccessMessage = 'Joke found';
const String categoryLabel = 'Categories';
const String blacklistLabel = 'Blacklists';
const String searchLabel = 'Search jokes';
const String keyWordLabel = 'Search for keywords';

class _JokesPageState extends State<JokesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Jokes Finder',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: BlocProvider(
          create: (context) => widget.bloc,
          child: BlocConsumer<JokeBloc, JokeState>(listener: (BuildContext context, JokeState state) {
            if (state.status == BlocStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.errorMessage ?? errorMessage),
              ));
              widget.bloc.add(const ResetJokeSubmit());
            }
          }, builder: (BuildContext context, JokeState state) {
            if (state.status == BlocStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (state.status == BlocStatus.loaded)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(submitSuccessMessage,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(state.setupJoke,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  state.deliveryJoke,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(categoryLabel, style: Theme.of(context).textTheme.titleMedium),
                    DropdownButtonJokesSelection(
                      list: JokeCategory.values.map((e) => e.toString().split('.').last).toList(),
                      currentList: state.categories,
                      onChanged: (String value, bool isSelected) {
                        if (isSelected) {
                          widget.bloc.add(AddCategoryJokeEvent(category: value));
                        } else {
                          widget.bloc.add(RemoveCategoryJokeEvent(category: value));
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(blacklistLabel, style: Theme.of(context).textTheme.titleMedium),
                    DropdownButtonJokesSelection(
                      list: BlackList.values.map((e) => e.toString().split('.').last).toList(),
                      currentList: state.blacklistFlags,
                      onChanged: (String value, bool isSelected) {
                        if (isSelected) {
                          widget.bloc.add(AddBlacklistFlagsJokeEvent(blacklistFlags: value));
                        } else {
                          widget.bloc.add(RemoveBlacklistFlagsJokeEvent(blacklistFlags: value));
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        validator: (value) {
                          return null;
                        },
                        controller: controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: keyWordLabel,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          widget.bloc.add(JokeEventSubmit(
                            searchString: controller.text,
                          ));
                        },
                        child: const Text(searchLabel)),
                  ],
                ),
              ),
            );
          }),
        ));
  }
}

class DropdownButtonJokesSelection extends StatefulWidget {
  const DropdownButtonJokesSelection({
    Key? key,
    required this.list,
    this.onChanged,
    required this.currentList,
  }) : super(key: key);
  final List<String> list;
  final JokeCheckBoxCallback? onChanged;
  final List<String> currentList;
  @override
  State<DropdownButtonJokesSelection> createState() => _DropdownButtonJokesSelectionState();
}

class _DropdownButtonJokesSelectionState extends State<DropdownButtonJokesSelection> {
  String dropdownValue = '';
  @override
  void initState() {
    super.initState();
    dropdownValue = widget.list.first;
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return TextButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('OPEN MENU'),
              Icon(Icons.arrow_downward_rounded),
            ],
          ),
        );
      },
      alignmentOffset: const Offset(100, 0),
      menuChildren: widget.list.map<CheckboxMenuButton>((String stringValue) {
        return CheckboxMenuButton(
          value: widget.currentList.contains(stringValue),
          onChanged: (bool? value) {
            if (widget.onChanged != null) {
              widget.onChanged!(stringValue, value!);
            }
          },
          child: Text(
            stringValue,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        );
      }).toList(),
    );
  }
}
