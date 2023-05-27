enum MessageType {
  message(0),
  reply(1),
  image(2),
  timeLine(3),
  file(4);

  const MessageType(this.value);
  final int value;
}
