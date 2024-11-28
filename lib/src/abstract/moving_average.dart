abstract class MovingAverage {
  /// Adiciona um valor e retorna o próximo valor da média móvel.
  double? next(double value);

  /// Calcula o valor atual sem alterar o estado interno.
  double? current(double value);
}
