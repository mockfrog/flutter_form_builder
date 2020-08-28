import 'package:flutter/material.dart';

typedef ValueTransformer<T> = dynamic Function(T value);

class FormBuilder extends StatefulWidget {
  //final BuildContext context;
  final Function(Map<String, dynamic>) onChanged;
  final WillPopCallback onWillPop;
  final WidgetBuilder builder;
  final bool readOnly;
  final bool autovalidate;
  final Map<String, dynamic> initialValue;

  const FormBuilder({
    Key key,
    @required this.builder,
    this.readOnly = false,
    this.onChanged,
    this.autovalidate = false,
    this.onWillPop,
    this.initialValue = const {},
  }) : super(key: key);

  static FormBuilderState of(BuildContext context) => context.findAncestorStateOfType<FormBuilderState>();

  @override
  FormBuilderState createState() => FormBuilderState();
}

class FormBuilderState extends State<FormBuilder> {
  //TODO: Find way to assert no duplicates in control attributes
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, GlobalKey<FormFieldState>> _fieldKeys;

  Map<String, dynamic> _value;

  Map<String, dynamic> get value => {...widget.initialValue ?? {}, ..._value};

  Map<String, dynamic> get initialValue => widget.initialValue;

  Map<String, GlobalKey<FormFieldState>> get fields => _fieldKeys;

  bool get readOnly => widget.readOnly;

  @override
  void initState() {
    _fieldKeys = {};
    _value = initialValue ?? {};
    super.initState();
  }

  @override
  void dispose() {
    _fieldKeys = null;
    super.dispose();
  }

  void updateValue(Map<String, dynamic> newValue) {
    setState(() {
      _value = newValue;
    });
  }

  int getListLength(String attribute) {
    /*var key = attribute;
    var pos = attribute.lastIndexOf(".");

    if (pos != -1) {
      key = attribute.substring(pos + 1);
      attribute = attribute.substring(0, pos);
    }*/

    dynamic ref = _value;
    while (attribute.length > 0) {
      var pos = attribute.indexOf(".");
      if (pos != -1) {
        if (ref is List<dynamic>) {
          var idx = int.parse(attribute.substring(0, pos));
          assert(ref.length > idx);
          ref = ref[idx];
        } else if (ref is Map<String, dynamic>) {
          var sub = attribute.substring(0, pos);
          ref = ref[sub];
        }
        attribute = attribute.substring(pos + 1);
      } else {
        if (ref is List<dynamic>) {
          var idx = int.parse(attribute);
          assert(ref.length > idx);
          ref = ref[idx];
        } else if (ref is Map<String, dynamic>) {
          ref = ref[attribute];
        }
        attribute = "";
      }
    }
    return (ref as List<dynamic>).length;
  }

  void addListItem(String attribute, Map<String, dynamic> listItem) {
    save();
    var key = attribute;
    var pos = attribute.lastIndexOf(".");

    if (pos != -1) {
      key = attribute.substring(pos + 1);
      attribute = attribute.substring(0, pos);
    }

    // key must be index
    int idx = int.tryParse(key);
    assert(idx != null);
    if (idx == null) {
      return;
    }

    dynamic ref = _value;
    while (attribute.length > 0) {
      pos = attribute.indexOf(".");
      if (pos != -1) {
        if (ref is List<dynamic>) {
          var idx = int.parse(attribute.substring(0, pos));
          assert(ref.length > idx);
          ref = ref[idx];
        } else if (ref is Map<String, dynamic>) {
          var sub = attribute.substring(0, pos);
          ref = ref[sub];
        }
        attribute = attribute.substring(pos + 1);
      } else {
        if (ref is List<dynamic>) {
          var idx = int.parse(attribute);
          assert(ref.length > idx);
          ref = ref[idx];
        } else if (ref is Map<String, dynamic>) {
          ref = ref[attribute];
        }
        attribute = "";
      }
    }
    setState(() {
      (ref as List<dynamic>).insert(idx, listItem);
    });
  }

  void removeListItem(String attribute) {
    save();
    var key = attribute;
    var pos = attribute.lastIndexOf(".");

    if (pos != -1) {
      key = attribute.substring(pos + 1);
      attribute = attribute.substring(0, pos);
    }

    // key must be index
    int idx = int.tryParse(key);
    assert(idx != null);
    if (idx == null) {
      return;
    }

    dynamic ref = _value;
    while (attribute.length > 0) {
      pos = attribute.indexOf(".");
      if (pos != -1) {
        if (ref is List<dynamic>) {
          var idx = int.parse(attribute.substring(0, pos));
          assert(ref.length > idx);
          ref = ref[idx];
        } else if (ref is Map<String, dynamic>) {
          var sub = attribute.substring(0, pos);
          ref = ref[sub];
        }
        attribute = attribute.substring(pos + 1);
      } else {
        if (ref is List<dynamic>) {
          var idx = int.parse(attribute);
          assert(ref.length > idx);
          ref = ref[idx];
        } else if (ref is Map<String, dynamic>) {
          ref = ref[attribute];
        }
        attribute = "";
      }
    }
    setState(() {
      (ref as List<dynamic>).removeAt(idx);
    });
  }

  bool hasAttributeValue(String attribute) {
    var key = attribute;
    var pos = attribute.lastIndexOf(".");

    if (pos != -1) {
      key = attribute.substring(pos + 1);
      attribute = attribute.substring(0, pos);
    } else {
      return _value.containsKey(key);
    }

    dynamic ref = _value;
    while (attribute.length > 0) {
      pos = attribute.indexOf(".");
      if (pos != -1) {
        if (ref is List<dynamic>) {
          var idx = int.parse(attribute.substring(0, pos));
          assert(ref.length > idx);
          ref = ref[idx];
        } else if (ref is Map<String, dynamic>) {
          var sub = attribute.substring(0, pos);
          ref = ref[sub];
        }
        attribute = attribute.substring(pos + 1);
      } else {
        if (ref is List<dynamic>) {
          var idx = int.parse(attribute);
          if (ref.length > idx) {
            ref = ref[idx];
          } else {
            return false;
          }
        } else if (ref is Map<String, dynamic>) {
          ref = ref[attribute];
        }
        attribute = "";
      }
    }
    return (ref is Map<String, dynamic>) && ref.containsKey(key);
  }

  dynamic getAttributeValue(String attribute) {
    var key = attribute;
    var pos = attribute.lastIndexOf(".");

    if (pos != -1) {
      key = attribute.substring(pos + 1);
      attribute = attribute.substring(0, pos);
    } else {
      return _value[key];
    }

    dynamic ref = _value;
    while (attribute.length > 0) {
      pos = attribute.indexOf(".");
      if (pos != -1) {
        if (ref is List<dynamic>) {
          var idx = int.parse(attribute.substring(0, pos));
          assert(ref.length > idx);
          ref = ref[idx];
        } else if (ref is Map<String, dynamic>) {
          var sub = attribute.substring(0, pos);
          ref = ref[sub];
        }
        attribute = attribute.substring(pos + 1);
      } else {
        if (ref is List<dynamic>) {
          var idx = int.parse(attribute);
          assert(ref.length > idx);
          ref = ref[idx];
        } else if (ref is Map<String, dynamic>) {
          ref = ref[attribute];
        }
        attribute = "";
      }
    }
    return ref[key];
  }

  void setAttributeValue(String attribute, dynamic value) {
    setState(() {
      var key = attribute;
      var pos = attribute.lastIndexOf(".");

      if (pos != -1) {
        key = attribute.substring(pos + 1);
        attribute = attribute.substring(0, pos);
      } else {
        assert(_value.containsKey(key));
        _value[key] = value;
        return;
      }

      dynamic ref = _value;
      while (attribute.length > 0) {
        pos = attribute.indexOf(".");
        if (pos != -1) {
          if (ref is List<dynamic>) {
            var idx = int.parse(attribute.substring(0, pos));
            assert(ref.length > idx);
            ref = ref[idx];
          } else if (ref is Map<String, dynamic>) {
            var sub = attribute.substring(0, pos);
            ref = ref[sub];
          }
          attribute = attribute.substring(pos + 1);
        } else {
          if (ref is List<dynamic>) {
            var idx = int.parse(attribute);
            if (ref.length > idx) {
              ref = ref[idx];
            } else {
              print("attribute could not be set");
              return;
            }
          } else if (ref is Map<String, dynamic>) {
            ref = ref[attribute];
          }
          attribute = "";
        }
      }
      ref[key] = value;
    });
  }

  registerFieldKey(String attribute, GlobalKey key) {
    // assert(_fieldKeys.containsKey(attribute) == false, "Field with attribute '$attribute' already exists. Make sure that two or more fields don't have the same attribute name.");
    this._fieldKeys[attribute] = key;
  }

  unregisterFieldKey(String attribute) {
    this._fieldKeys.remove(attribute);
  }

  /*changeAttributeValue(String attribute, dynamic newValue) {
    print(this.fieldKeys[attribute]);
    if (this.fieldKeys[attribute] != null){
      print("Current $attribute value: ${this.fieldKeys[attribute].currentState.value}");
      print("Trying to change $attribute to $newValue");
      this.fieldKeys[attribute].currentState.didChange(newValue);
      print("$attribute value after: ${this.fieldKeys[attribute].currentState.value}");
    }
  }*/

  void save() {
    _formKey.currentState.save();
  }

  bool validate() {
    return _formKey.currentState.validate();
  }

  bool saveAndValidate() {
    _formKey.currentState.save();
    return _formKey.currentState.validate();
  }

  void reset() {
    _formKey.currentState.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: widget.builder(context),
      autovalidate: widget.autovalidate,
      onWillPop: widget.onWillPop,
      onChanged: () {
        if (widget.onChanged != null) {
          save();
          widget.onChanged(value);
        }
      },
    );
  }
}
