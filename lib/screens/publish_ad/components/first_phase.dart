import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/models/ad_model.dart';
import 'package:fly_ads_demo1/models/area_model.dart';
import 'package:fly_ads_demo1/utils/constants.dart';
import 'package:intl/intl.dart';

class FirstPhasePublishAD extends StatefulWidget {
  final List<AreaModel> areas;
  final Function phaseCompleted;

  const FirstPhasePublishAD(
      {Key? key, required this.areas, required this.phaseCompleted})
      : super(key: key);

  @override
  State<FirstPhasePublishAD> createState() => _FirstPhasePublishADState();
}

class _FirstPhasePublishADState extends State<FirstPhasePublishAD> {
  final List<String> _selectedAreas = [];

  TextEditingController nameController = TextEditingController(),
      startDateController = TextEditingController(),
      endDateController = TextEditingController();

  DateTime? startDate, endDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        const Text('Enter Name of Campaign'),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person_outline_rounded),
            labelText: 'Name',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: appPrimaryColor.shade900),
              borderRadius: const BorderRadius.all(
                Radius.circular(6.0),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        DropdownButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            hint: const Text('Select Area'),
            isExpanded: true,
            items: widget.areas.map((AreaModel e) {
              return DropdownMenuItem(
                value: e.id!,
                child: Text(
                  e.name ?? '',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: !_selectedAreas.contains(e.id)
                          ? Colors.black
                          : Colors.black45),
                ),
                enabled: !_selectedAreas.contains(e.id),
              );
            }).toList(),
            onChanged: (String? id) {
              setState(() {
                _selectedAreas.add(id!);
              });
            }),
        const SizedBox(
          height: 5,
        ),
        _buildSelectedAreaWidget(),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
                child: InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: startDate ?? DateTime.now(),
                  firstDate: startDate ?? DateTime.now(),
                  lastDate: DateTime((startDate ?? DateTime.now()).year + 1),
                );

                if (picked != null) {
                  startDateController.text =
                      DateFormat('dd-MM-yyyy').format(picked);
                  setState(() {
                    startDate = picked;
                  });
                }
              },
              child: TextField(
                controller: startDateController,
                enabled: false,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.date_range_rounded),
                  labelText: 'Select Start Date',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: appPrimaryColor.shade900),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(6.0),
                    ),
                  ),
                ),
              ),
            )),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: (endDate ?? startDate) ?? DateTime.now(),
                  firstDate: startDate ?? DateTime.now(),
                  lastDate: DateTime((startDate ?? DateTime.now()).year + 1),
                );
                if (picked != null) {
                  endDateController.text =
                      DateFormat('dd-MM-yyyy').format(picked);
                  setState(() {
                    endDate = picked;
                  });
                }
              },
              child: TextField(
                enabled: false,
                controller: endDateController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.date_range_rounded),
                  labelText: 'Select End Date',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: appPrimaryColor.shade900),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(6.0),
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Center(
            child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty ||
                      _selectedAreas.isEmpty ||
                      startDate == null ||
                      endDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please enter all details'),
                    ));
                    return;
                  }
                  widget.phaseCompleted(AdModel(
                      campaignName: nameController.text,
                      areaIDs: _selectedAreas.map((e) => int.parse(e)).toList(),
                      startDate: Timestamp.fromDate(startDate!),
                      endDate: Timestamp.fromDate(endDate!),
                      price: 0.00));
                },
                child: Text(
                  'Next Step',
                  style: Theme.of(context).textTheme.subtitle1,
                )))
      ],
    );
  }

  Widget _buildSelectedAreaWidget() {
    List<AreaModel> areaList = [];

    for (String i in _selectedAreas) {
      for (AreaModel a in widget.areas) {
        if (i == a.id) {
          areaList.add(a);
        }
      }
    }

    return Wrap(
      children: areaList.map((AreaModel e) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: const BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.all(Radius.circular(3))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                e.name ?? '',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  _selectedAreas.remove(e.id);
                  setState(() {});
                },
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Colors.red.shade900,
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
