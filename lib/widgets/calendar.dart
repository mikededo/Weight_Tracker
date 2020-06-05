import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:google_fonts/google_fonts.dart';

class Calendar extends StatelessWidget {
  final DateTime selectedDateTime;
  final Function(DateTime date, List<dynamic> list) onDayPressed;

  const Calendar({this.selectedDateTime, this.onDayPressed});

  @override
  Widget build(BuildContext context) {
    return CalendarCarousel<Event>(
      thisMonthDayBorderColor: Colors.transparent,
      selectedDayButtonColor: Theme.of(context).accentColor.withOpacity(0.75),
      selectedDayBorderColor: Colors.transparent,
      selectedDayTextStyle: GoogleFonts.workSans().copyWith(
        color: Colors.white,
      ),
      weekendTextStyle:
          GoogleFonts.workSans().copyWith(color: Color(0xFF8a8b98)),
      daysTextStyle: GoogleFonts.workSans().copyWith(color: Color(0xFF8a8b98)),
      todayButtonColor: Colors.transparent,
      todayBorderColor: Colors.transparent,
      todayTextStyle: GoogleFonts.workSans().copyWith(
        color: Theme.of(context).accentColor,
      ),
      nextDaysTextStyle: TextStyle(color: Colors.transparent),
      prevDaysTextStyle: TextStyle(color: Colors.transparent),
      weekdayTextStyle: GoogleFonts.workSans().copyWith(color: Colors.white),
      headerTextStyle: Theme.of(context).textTheme.subtitle1,
      showHeaderButton: false,
      weekDayFormat: WeekdayFormat.narrow,
      iconColor: Color(0xFF8a8b98),
      firstDayOfWeek: 1,
      showHeader: true,
      headerMargin: const EdgeInsets.only(bottom: 8.0),
      isScrollable: true,
      pageScrollPhysics: PageScrollPhysics(),
      weekFormat: false,
      height: MediaQuery.of(context).size.height * 0.4,
      selectedDateTime: selectedDateTime,
      daysHaveCircularBorder: true,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      onDayPressed: onDayPressed,
    );
  }
}
