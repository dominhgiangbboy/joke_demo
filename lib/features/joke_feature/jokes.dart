import 'package:demo_for_vnext/data/joke.dart';
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

class _JokesPageState extends State<JokesPage> {
  final _formKey = GlobalKey<FormState>();
  JokeCategory currentCategory = JokeCategory.any;
  BlackList currentBlackList = BlackList.nsfw;
  String currentSearchString = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Jokes',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: BlocProvider(
          create: (context) => widget.bloc,
          child: BlocConsumer<JokeBloc, JokeState>(listener: (BuildContext context, JokeState state) {
            if (state.status == BlocStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Error submitting joke'),
              ));
              widget.bloc.add(const ResetJokeSubmit());
            }
          }, builder: (BuildContext context, JokeState state) {
            if (state.status == BlocStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Categories', style: Theme.of(context).textTheme.titleMedium),
                  DropdownButtonJokesSelection(
                    list: JokeCategory.values.map((e) => e.toString().split('.').last).toList(),
                    onChanged: (value) {
                      currentCategory = JokeCategory.values.firstWhere((e) => e.toString() == 'JokeCategory.$value');
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Blacklists', style: Theme.of(context).textTheme.titleMedium),
                  DropdownButtonJokesSelection(
                    list: BlackList.values.map((e) => e.toString().split('.').last).toList(),
                    onChanged: (value) {
                      currentBlackList = BlackList.values.firstWhere((e) => e.toString() == 'BlackList.$value');
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search for a jokes',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.bloc.add(JokeEventSubmit(
                            joke: JokeEntity(
                              category: currentCategory,
                              blacklist: currentBlackList,
                              searchString: currentSearchString,
                            ),
                          ));
                        }
                      },
                      child: const Text('Submit')),
                ],
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
  }) : super(key: key);
  final List<String> list;
  final StringCallback? onChanged;
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
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      borderRadius: BorderRadius.circular(20),
      focusColor: Colors.deepPurple,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(value!);
        }
      },
      items: widget.list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
