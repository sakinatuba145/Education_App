import 'package:flutter/material.dart';

/// Centralized icon definitions for semantic usage throughout the app
/// Grouped by functional categories
class AppIcons {
  // =============== NAVIGATION & GENERAL ===============
  static const IconData home = Icons.home_outlined;
  static const IconData homeOutlined = Icons.home_outlined;
  static const IconData homeFilled = Icons.home_filled;
  static const IconData back = Icons.arrow_back;
  static const IconData forward = Icons.arrow_forward;
  static const IconData close = Icons.close;
  static const IconData menu = Icons.menu;
  static const IconData search = Icons.search;
  static const IconData settings = Icons.settings_outlined;
  static const IconData notification = Icons.notifications_outlined;
  static const IconData filter = Icons.filter_list;
  static const IconData sort = Icons.sort;
  static const IconData moreVert = Icons.more_vert;
  static const IconData moreHoriz = Icons.more_horiz;

  // =============== COURSE & CONTENT ACTIONS ===============
  static const IconData play = Icons.play_circle_outline;
  static const IconData playFilled = Icons.play_circle_filled;
  static const IconData pause = Icons.pause_circle_outline;
  static const IconData pauseFilled = Icons.pause_circle_filled;
  static const IconData skip = Icons.skip_next;
  static const IconData replay = Icons.replay;
  static const IconData fullscreen = Icons.fullscreen;
  static const IconData exitFullscreen = Icons.fullscreen_exit;

  // =============== UPLOAD & FILE OPERATIONS ===============
  static const IconData upload = Icons.cloud_upload_outlined;
  static const IconData uploadFilled = Icons.cloud_upload;
  static const IconData download = Icons.download_outlined;
  static const IconData downloadFilled = Icons.download;
  static const IconData attach = Icons.attach_file;
  static const IconData share = Icons.share;
  static const IconData delete = Icons.delete_outline;
  static const IconData deleteFilled = Icons.delete;
  static const IconData edit = Icons.edit_outlined;
  static const IconData editFilled = Icons.edit;

  // =============== CONTENT TYPES ===============
  static const IconData video = Icons.video_library_outlined;
  static const IconData videoFilled = Icons.video_library;
  static const IconData image = Icons.image_outlined;
  static const IconData imageFilled = Icons.image;
  static const IconData audio = Icons.audio_file_outlined;
  static const IconData audioFilled = Icons.audio_file;
  static const IconData pdf = Icons.picture_as_pdf_outlined;
  static const IconData pdfFilled = Icons.picture_as_pdf;
  static const IconData document = Icons.description_outlined;
  static const IconData documentFilled = Icons.description;
  static const IconData file = Icons.file_present;

  // =============== STATUS INDICATORS ===============
  static const IconData complete = Icons.check_circle;
  static const IconData completeFilled = Icons.done_all;
  static const IconData incomplete = Icons.radio_button_unchecked;
  static const IconData inProgress = Icons.schedule;
  static const IconData inProgressFilled = Icons.schedule;
  static const IconData pending = Icons.schedule;
  static const IconData alert = Icons.warning_outlined;
  static const IconData alertFilled = Icons.warning;
  static const IconData error = Icons.error_outline;
  static const IconData errorFilled = Icons.error;
  static const IconData success = Icons.check_circle;
  static const IconData successFilled = Icons.done;

  // =============== INTERACTIVE ELEMENTS ===============
  static const IconData add = Icons.add;
  static const IconData addCircle = Icons.add_circle_outline;
  static const IconData addCircleFilled = Icons.add_circle;
  static const IconData remove = Icons.remove;
  static const IconData removeCircle = Icons.remove_circle_outline;
  static const IconData bookmark = Icons.bookmark_outline;
  static const IconData bookmarkFilled = Icons.bookmark;
  static const IconData favorite = Icons.favorite_outline;
  static const IconData favoriteFilled = Icons.favorite;
  static const IconData star = Icons.star_outline;
  static const IconData starFilled = Icons.star;
  static const IconData halfStar = Icons.star_half;
  static const IconData like = Icons.thumb_up_outlined;
  static const IconData likeFilled = Icons.thumb_up;
  static const IconData dislike = Icons.thumb_down_outlined;
  static const IconData dislikeFilled = Icons.thumb_down;

  // =============== USER & PROFILE ===============
  static const IconData profile = Icons.person_outline;
  static const IconData profileFilled = Icons.person;
  static const IconData people = Icons.people_outline;
  static const IconData peopleFilled = Icons.people;
  static const IconData teacher = Icons.school_outlined;
  static const IconData student = Icons.person_outline;
  static const IconData logout = Icons.logout;
  static const IconData login = Icons.login;

  // =============== COURSE MANAGEMENT ===============
  static const IconData course = Icons.menu_book_outlined;
  static const IconData courseFilled = Icons.menu_book;
  static const IconData lesson = Icons.library_books_outlined;
  static const IconData lessonFilled = Icons.library_books;
  static const IconData quiz = Icons.quiz_outlined;
  static const IconData quizFilled = Icons.quiz;
  static const IconData certificate = Icons.card_membership;
  static const IconData deadline = Icons.event;
  static const IconData duration = Icons.schedule;
  static const IconData difficulty = Icons.trending_up;

  // =============== ANALYTICS & CHARTS ===============
  static const IconData chart = Icons.analytics_outlined;
  static const IconData chartFilled = Icons.analytics;
  static const IconData trending = Icons.trending_up;
  static const IconData trendingDown = Icons.trending_down;
  static const IconData insights = Icons.insights;
  static const IconData percent = Icons.percent;
  static const IconData statistics = Icons.bar_chart;

  // =============== COMMUNICATION ===============
  static const IconData message = Icons.message_outlined;
  static const IconData messageFilled = Icons.message;
  static const IconData chat = Icons.chat_bubble_outline;
  static const IconData chatFilled = Icons.chat_bubble;
  static const IconData comment = Icons.comment_outlined;
  static const IconData commentFilled = Icons.comment;
  static const IconData email = Icons.email_outlined;
  static const IconData emailFilled = Icons.email;
  static const IconData phone = Icons.phone_outlined;
  static const IconData phoneFilled = Icons.phone;

  // =============== UI CONTROL ===============
  static const IconData done = Icons.done;
  static const IconData next = Icons.navigate_next;
  static const IconData previous = Icons.navigate_before;
  static const IconData chevronDown = Icons.expand_more;
  static const IconData chevronUp = Icons.expand_less;
  static const IconData chevronLeft = Icons.chevron_left;
  static const IconData chevronRight = Icons.chevron_right;
  static const IconData expand = Icons.expand;
  static const IconData collapse = Icons.unfold_less;
  static const IconData dragHandle = Icons.drag_handle;
  static const IconData check = Icons.check;
  static const IconData clear = Icons.clear;
  static const IconData refresh = Icons.refresh;
  static const IconData reload = Icons.cached;

  // =============== UTILITY & SYSTEM ===============
  static const IconData info = Icons.info_outline;
  static const IconData infoFilled = Icons.info;
  static const IconData help = Icons.help_outline;
  static const IconData helpFilled = Icons.help;
  static const IconData about = Icons.info_outline;
  static const IconData privacy = Icons.privacy_tip;
  static const IconData security = Icons.security;
  static const IconData block = Icons.block;
  static const IconData report = Icons.report_outlined;
  static const IconData bug = Icons.bug_report_outlined;
  static const IconData feedback = Icons.feedback_outlined;

  // =============== STATUS-TO-ICON MAPPING ===============
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'done':
      case 'finished':
        return complete;
      case 'in-progress':
      case 'in_progress':
      case 'ongoing':
        return inProgress;
      case 'pending':
      case 'draft':
        return pending;
      case 'not-started':
      case 'not_started':
        return incomplete;
      case 'failed':
      case 'error':
        return error;
      default:
        return incomplete;
    }
  }

  /// Get filled variant of icon
  static IconData getFilled(IconData icon) {
    if (icon == play) return playFilled;
    if (icon == pause) return pauseFilled;
    if (icon == upload) return uploadFilled;
    if (icon == download) return downloadFilled;
    if (icon == delete) return deleteFilled;
    if (icon == edit) return editFilled;
    if (icon == video) return videoFilled;
    if (icon == image) return imageFilled;
    if (icon == audio) return audioFilled;
    if (icon == pdf) return pdfFilled;
    if (icon == document) return documentFilled;
    if (icon == complete) return successFilled;
    if (icon == incomplete) return complete;
    if (icon == bookmark) return bookmarkFilled;
    if (icon == favorite) return favoriteFilled;
    if (icon == star) return starFilled;
    if (icon == like) return likeFilled;
    if (icon == profile) return profileFilled;
    if (icon == course) return courseFilled;
    if (icon == lesson) return lessonFilled;

    // Default: return the original icon
    return icon;
  }

  /// Get outlined variant of icon
  static IconData getOutlined(IconData icon) {
    if (icon == playFilled) return play;
    if (icon == pauseFilled) return pause;
    if (icon == uploadFilled) return upload;
    if (icon == downloadFilled) return download;
    if (icon == deleteFilled) return delete;
    if (icon == editFilled) return edit;
    if (icon == videoFilled) return video;
    if (icon == imageFilled) return image;
    if (icon == audioFilled) return audio;
    if (icon == pdfFilled) return pdf;
    if (icon == documentFilled) return document;

    // Default: return the original icon
    return icon;
  }
}
