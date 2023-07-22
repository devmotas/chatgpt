mixin ValidationsMixing {
  String? isNotEmpty(String? value, [String? message]) {
    if (value!.isEmpty) return message ?? "Este campo é obrigatório si";
    return null;
  }

  String? isEqual(String? value1, String? value2, [String? message]) {
    if (value1!.isNotEmpty && value2!.isNotEmpty && value1 == value2) {
      return message ?? "Valores diferentes.";
    }
    return null;
  }

  String? hasChars(String? value, int? chars, [String? message]) {
    if (value!.length < chars!) {
      return message ?? "Você deve usar pelo menso $chars caracteres!";
    }
    return null;
  }

  String? combine(List<String? Function()> validators) {
    for (final func in validators) {
      final validation = func();
      if (validation != null) return validation;
    }
    return null;
  }
}
