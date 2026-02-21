import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventEmployee extends StatefulWidget {
  const EventEmployee({super.key});

  @override
  State<EventEmployee> createState() => _EventEmployeeState();
}

class _EventEmployeeState extends State<EventEmployee> {
  int _currentIndex = 0;
  final List<Event> _events = [];
  
  // قائمة أنواع الأحداث
  final List<String> eventTypes = [
    'كهرباء',
    'ماء',
    'صيانة عامة',
    'صرف صحي',
    'أمانة المدينة',
    'خدمات بلدية أخرى'
  ];
  
  // قائمة المناطق المتأثرة
  final List<String> areas = [
    'المنطقة الشمالية',
    'المنطقة الجنوبية',
    'المنطقة الشرقية',
    'المنطقة الغربية',
    'المنطقة الوسطى',
    'جميع المناطق'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('موظف إدارة الأحداث'),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateEventPage(
                    onEventCreated: (newEvent) {
                      setState(() {
                        _events.add(newEvent);
                      });
                    },
                    eventTypes: eventTypes,
                    areas: areas,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'الأحداث',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'التقويم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الملف الشخصي',
          ),
        ],
      ),
    );
  }
  
  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return EventsListPage(events: _events, eventTypes: eventTypes);
      case 1:
        return CalendarPage(events: _events);
      case 2:
        return ProfilePage();
      default:
        return EventsListPage(events: _events, eventTypes: eventTypes);
    }
  }
}

// صفحة قائمة الأحداث
class EventsListPage extends StatelessWidget {
  final List<Event> events;
  final List<String> eventTypes;
  
  const EventsListPage({
    super.key,
    required this.events,
    required this.eventTypes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // فلترة الأحداث
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'تصفية الأحداث',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('الكل'),
                        onSelected: (_) {},
                        selected: true,
                      ),
                      ...eventTypes.map((type) => FilterChip(
                        label: Text(type),
                        onSelected: (_) {},
                      )).toList(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // قائمة الأحداث
        Expanded(
          child: events.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_busy, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'لا توجد أحداث حالياً',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        'انقر على + لإضافة حدث جديد',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return EventCard(event: event);
                  },
                ),
        ),
      ],
    );
  }
}

// بطاقة الحدث
class EventCard extends StatelessWidget {
  final Event event;
  
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.pending;
    
    switch (event.status) {
      case 'مخطط':
        statusColor = Colors.blue;
        statusIcon = Icons.schedule;
        break;
      case 'جاري':
        statusColor = Colors.orange;
        statusIcon = Icons.play_arrow;
        break;
      case 'منتهي':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
    }
    
    Color typeColor = Colors.blue;
    IconData typeIcon = Icons.event;
    
    switch (event.eventType) {
      case 'كهرباء':
        typeColor = Colors.amber;
        typeIcon = Icons.flash_on;
        break;
      case 'ماء':
        typeColor = Colors.blue;
        typeIcon = Icons.water_drop;
        break;
      case 'صيانة عامة':
        typeColor = Colors.green;
        typeIcon = Icons.engineering;
        break;
    }

    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: typeColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(typeIcon, color: typeColor),
        ),
        title: Text(event.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              event.description.length > 50 
                ? '${event.description.substring(0, 50)}...' 
                : event.description,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(event.location, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, size: 12, color: statusColor),
                  const SizedBox(width: 4),
                  Text(
                    event.status,
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('MM/dd').format(event.startDate),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsPage(event: event),
            ),
          );
        },
      ),
    );
  }
}

// صفحة إنشاء حدث جديد
class CreateEventPage extends StatefulWidget {
  final Function(Event) onEventCreated;
  final List<String> eventTypes;
  final List<String> areas;
  
  const CreateEventPage({
    super.key,
    required this.onEventCreated,
    required this.eventTypes,
    required this.areas,
  });

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  String _selectedEventType = 'كهرباء';
  List<String> _selectedAreas = [];
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  String _status = 'مخطط';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حدث جديد'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveEvent,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // نوع الحدث
              const Text('نوع الحدث:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.eventTypes.map((type) {
                  return ChoiceChip(
                    label: Text(type),
                    selected: _selectedEventType == type,
                    onSelected: (selected) {
                      setState(() {
                        _selectedEventType = type;
                      });
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // عنوان الحدث
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان الحدث',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال عنوان الحدث';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // وصف الحدث
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'وصف الحدث',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال وصف الحدث';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // الموقع
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'الموقع',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الموقع';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // المناطق المتأثرة
              const Text('المناطق المتأثرة:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.areas.map((area) {
                  return FilterChip(
                    label: Text(area),
                    selected: _selectedAreas.contains(area),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedAreas.add(area);
                        } else {
                          _selectedAreas.remove(area);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // تواريخ البدء والانتهاء
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('تاريخ البدء:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _startDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(() {
                                _startDate = date;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 20),
                                const SizedBox(width: 8),
                                Text(DateFormat('yyyy/MM/dd').format(_startDate)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('تاريخ الانتهاء:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _endDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(() {
                                _endDate = date;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 20),
                                const SizedBox(width: 8),
                                Text(DateFormat('yyyy/MM/dd').format(_endDate)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // حالة الحدث
              const Text('حالة الحدث:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('مخطط'),
                      selected: _status == 'مخطط',
                      onSelected: (selected) {
                        setState(() {
                          _status = 'مخطط';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('جاري'),
                      selected: _status == 'جاري',
                      onSelected: (selected) {
                        setState(() {
                          _status = 'جاري';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('منتهي'),
                      selected: _status == 'منتهي',
                      onSelected: (selected) {
                        setState(() {
                          _status = 'منتهي';
                        });
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // زر الحفظ
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveEvent,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue[800],
                  ),
                  child: const Text(
                    'حفظ الحدث',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _saveEvent() {
    if (_formKey.currentState!.validate() && _selectedAreas.isNotEmpty) {
      final newEvent = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        startDate: _startDate,
        endDate: _endDate,
        eventType: _selectedEventType,
        location: _locationController.text,
        affectedAreas: _selectedAreas,
        status: _status,
        createdBy: 'موظف الأحداث',
        createdAt: DateTime.now(),
      );
      
      widget.onEventCreated(newEvent);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم إنشاء الحدث بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
    } else if (_selectedAreas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار منطقة واحدة على الأقل'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// صفحة تفاصيل الحدث
class EventDetailsPage extends StatelessWidget {
  final Event event;
  
  const EventDetailsPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الحدث'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            event.eventType == 'كهرباء' ? Icons.flash_on :
                            event.eventType == 'ماء' ? Icons.water_drop :
                            Icons.engineering,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      event.description,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // معلومات الحدث
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'معلومات الحدث',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildInfoRow('نوع الحدث:', event.eventType),
                    const Divider(),
                    _buildInfoRow('الموقع:', event.location),
                    const Divider(),
                    _buildInfoRow('تاريخ البدء:', DateFormat('yyyy/MM/dd HH:mm').format(event.startDate)),
                    const Divider(),
                    _buildInfoRow('تاريخ الانتهاء:', DateFormat('yyyy/MM/dd HH:mm').format(event.endDate)),
                    const Divider(),
                    _buildInfoRow('الحالة:', event.status),
                    const Divider(),
                    _buildInfoRow('تم الإنشاء بواسطة:', event.createdBy),
                    const Divider(),
                    _buildInfoRow('تاريخ الإنشاء:', DateFormat('yyyy/MM/dd HH:mm').format(event.createdAt)),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // المناطق المتأثرة
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'المناطق المتأثرة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: event.affectedAreas.map((area) {
                        return Chip(
                          label: Text(area),
                          backgroundColor: Colors.blue[50],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // أزرار الإجراءات
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // زر تعديل
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('تعديل'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // زر مشاركة
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('مشاركة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

// صفحة التقويم
class CalendarPage extends StatelessWidget {
  final List<Event> events;
  
  const CalendarPage({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    // تجميع الأحداث حسب التاريخ
    Map<String, List<Event>> eventsByDate = {};
    for (var event in events) {
      String dateKey = DateFormat('yyyy-MM-dd').format(event.startDate);
      if (!eventsByDate.containsKey(dateKey)) {
        eventsByDate[dateKey] = [];
      }
      eventsByDate[dateKey]!.add(event);
    }
    
    return ListView.builder(
      itemCount: eventsByDate.length,
      itemBuilder: (context, index) {
        String date = eventsByDate.keys.elementAt(index);
        List<Event> dayEvents = eventsByDate[date]!;
        
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, d MMMM yyyy', 'ar').format(DateTime.parse(date)),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...dayEvents.map((event) => ListTile(
                  leading: Icon(
                    event.eventType == 'كهرباء' ? Icons.flash_on :
                    event.eventType == 'ماء' ? Icons.water_drop :
                    Icons.engineering,
                    color: Colors.blue,
                  ),
                  title: Text(event.title),
                  subtitle: Text('${event.eventType} - ${event.location}'),
                  trailing: Text(DateFormat('HH:mm').format(event.startDate)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailsPage(event: event),
                      ),
                    );
                  },
                )).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// صفحة الملف الشخصي
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          const SizedBox(height: 20),
          const Text(
            'موظف الأحداث',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'القسم البلدية',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 40),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('البريد الإلكتروني'),
                    subtitle: const Text('employee@municipality.com'),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('رقم الهاتف'),
                    subtitle: const Text('+966 50 123 4567'),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.work),
                    title: const Text('عدد الأحداث المنشأة'),
                    subtitle: const Text('24 حدث'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// نموذج بيانات الحدث
class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String eventType;
  final String location;
  final List<String> affectedAreas;
  final String status; // 'مخطط', 'جاري', 'منتهي'
  final String createdBy;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.eventType,
    required this.location,
    required this.affectedAreas,
    required this.status,
    required this.createdBy,
    required this.createdAt,
  });
}
