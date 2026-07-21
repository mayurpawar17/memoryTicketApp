enum TicketType {
  flightBoardingPass,
  movieTicket,
  concertTicket,
  graduationTicket,
  cafeReceipt,
  birthdayTicket,
  vintageTicket,
  passportStamp,
  adventurePass,
  classicTicket,
}

extension TicketTypeExtension on TicketType {
  String get displayName {
    switch (this) {
      case TicketType.flightBoardingPass:
        return 'Flight Boarding Pass';
      case TicketType.movieTicket:
        return 'Movie Ticket';
      case TicketType.concertTicket:
        return 'Concert Ticket';
      case TicketType.graduationTicket:
        return 'Graduation Ticket';
      case TicketType.cafeReceipt:
        return 'Café Receipt';
      case TicketType.birthdayTicket:
        return 'Birthday Ticket';
      case TicketType.vintageTicket:
        return 'Vintage Ticket';
      case TicketType.passportStamp:
        return 'Passport Stamp';
      case TicketType.adventurePass:
        return 'Adventure Pass';
      case TicketType.classicTicket:
        return 'Classic Ticket';
    }
  }

  String get icon {
    switch (this) {
      case TicketType.flightBoardingPass:
        return '✈';
      case TicketType.movieTicket:
        return '🎬';
      case TicketType.concertTicket:
        return '🎤';
      case TicketType.graduationTicket:
        return '🎓';
      case TicketType.cafeReceipt:
        return '☕';
      case TicketType.birthdayTicket:
        return '🎂';
      case TicketType.vintageTicket:
        return '📜';
      case TicketType.passportStamp:
        return '🛂';
      case TicketType.adventurePass:
        return '🏕';
      case TicketType.classicTicket:
        return '🎟';
    }
  }
}
