import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ParameterProvider.dart';
import '../utils/CustomDropdown.dart';

class Labparameterscreen extends StatefulWidget {
  @override
  _LabParameterScreen createState() => _LabParameterScreen();
}

class _LabParameterScreen extends State<Labparameterscreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParameterProvider(),
      child: Consumer<ParameterProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Select Lab/Parameter'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select lab where sample has been taken:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 0,
                          groupValue: provider.selectionType,
                          onChanged: (value) =>{
                            provider.setSelectionType(value!),
                            provider.fetchAllLabs("31", "471", "4902", "167838", "397110", "1")
                          }
                        ),
                        Text('As per laboratory'),
                        Radio(
                          value: 1,
                          groupValue: provider.selectionType,
                          onChanged: (value) =>
                              provider.setSelectionType(value!),
                        ),
                        Text('As per parameters'),
                      ],
                    ),
                    if (provider.selectionType == 0) ...[
                      CustomDropdown(
                        title: "Select Lab *",
                        value: provider.selectedLab,
                        items: provider.labList.map((labId) {
                          return DropdownMenuItem<String>(
                              value: labId.value,
                              child: Text(
                                labId.text,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ));
                        }).toList(),
                        onChanged: (value)  {
                          provider.setSelectedLab(value);
                        },
                      )
                    ],
                    Visibility(
                      visible: provider.selectionType == 0,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 4,
                        margin: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Parameter Type:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              DropdownButton<int>(
                                isExpanded: true,
                                value: provider.parameterType,
                                items: [
                                  DropdownMenuItem(
                                      value: 0, child: Text('All Parameter')),
                                  DropdownMenuItem(
                                      value: 1,
                                      child: Text('Chemical Parameter')),
                                  DropdownMenuItem(
                                      value: 2,
                                      child: Text('Bacteriological Parameter')),
                                ],
                                onChanged: (value) =>
                                    provider.setParameterType(value!),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 4,
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tests Available:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: const <DataColumn>[
                                  DataColumn(label: Text('Sr. No.')),
                                  DataColumn(label: Text('Test Name')),
                                  DataColumn(label: Text('Test Price')),
                                  DataColumn(label: Text('Select Test')),
                                ],
                                rows: List<DataRow>.generate(
                                  provider.getParameters().length,
                                  (index) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text('${index + 1}')),
                                      DataCell(Text(
                                          provider.getParameters()[index])),
                                      DataCell(Text('0')),
                                      DataCell(
                                        Checkbox(
                                          value: provider.cart.contains(
                                              provider.getParameters()[index]),
                                          onChanged: (bool? value) =>
                                              provider.toggleCart(provider
                                                  .getParameters()[index]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text('Cart: ${provider.cart.join(', ')}'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
