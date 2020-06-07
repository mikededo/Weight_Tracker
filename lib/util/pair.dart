class Pair<F, S> {
  F first;
  S second;

  Pair({this.first, this.second});

  Pair<F, S> copyWith({
    F first,
    S second,
  }) {
    return Pair<F, S>(
      first: first ?? this.first,
      second: second ?? this.second,
    );
  }

  @override
  String toString() => 'Pair(first: $first, second: $second)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) {
      return true;
    }

    return o is Pair<F, S> && o.first == first && o.second == second;
  }

  @override
  int get hashCode => first.hashCode ^ second.hashCode;
}
