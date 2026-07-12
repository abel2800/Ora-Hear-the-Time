import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/settings_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/alarm_service.dart';
import '../../../services/background_service.dart';
import '../../../services/settings_provider.dart';

class AnnouncementsSettingsScreen extends StatelessWidget {
  const AnnouncementsSettingsScreen({super.key});

  static String _repeatLabel(int count, AppLocalizations l10n) {
    return switch (count) {
      1 => l10n.once,
      2 => l10n.twice,
      3 => l10n.threeTimes,
      4 => l10n.fourTimes,
      5 => l10n.fiveTimes,
      _ => l10n.twice,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final alarm = context.watch<AlarmService>();
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.announcements)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassCard(
            semanticsLabel: l10n.nextAnnouncementPreview,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(PhosphorIconsRegular.clockCountdown, color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: 8),
                    Text(l10n.statusInformation, style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                const SizedBox(height: 12),
                _StatusRow(
                  label: l10n.announcementIntervalLabel,
                  value: alarm.intervalMinutes > 0
                      ? '${l10n.every} ${alarm.intervalMinutes} ${l10n.minutes}'
                      : l10n.announcementsOff,
                ),
                _StatusRow(
                  label: l10n.nextAnnouncement,
                  value: alarm.nextAnnouncementTime != null
                      ? TimeUtils.formatTimeShort(alarm.nextAnnouncementTime!)
                      : l10n.notScheduled,
                ),
                _StatusRow(
                  label: l10n.repeatCount,
                  value: _repeatLabel(settings.repeatCount, l10n),
                ),
                if (alarm.lastAnnouncementText != null)
                  _StatusRow(label: l10n.lastAnnouncement, value: alarm.lastAnnouncementText!),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SettingsSectionHeader(title: l10n.announcementInterval, icon: PhosphorIconsRegular.timer),
          const SizedBox(height: 8),
          _IntervalSelector(),
          const SizedBox(height: 20),
          SettingsSectionHeader(title: l10n.repeatCount),
          const SizedBox(height: 8),
          _RepeatSelector(),
          const SizedBox(height: 20),
          SettingsSectionHeader(title: l10n.quietHours, icon: PhosphorIconsFill.moon),
          const SizedBox(height: 8),
          _QuietHoursCard(),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _IntervalSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final alarm = context.watch<AlarmService>();

    final options = [
      (0, l10n.noRepeat),
      (15, l10n.every15Minutes),
      (30, l10n.every30Minutes),
      (60, l10n.everyHour),
    ];

    return Column(
      children: options.map((opt) {
        final selected = alarm.intervalMinutes == opt.$1;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Semantics(
            selected: selected,
            button: true,
            label: opt.$2,
            child: Card(
              color: selected
                  ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12)
                  : null,
              child: ListTile(
                leading: Icon(
                  selected ? PhosphorIconsFill.checkCircle : PhosphorIconsRegular.circle,
                  color: selected ? Theme.of(context).colorScheme.secondary : null,
                ),
                title: Text(opt.$2, style: TextStyle(fontWeight: selected ? FontWeight.w700 : null)),
                onTap: () => alarm.setInterval(opt.$1),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _RepeatSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsProvider>();

    final options = [
      (1, l10n.once),
      (2, l10n.twice),
      (3, l10n.threeTimes),
      (4, l10n.fourTimes),
      (5, l10n.fiveTimes),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final selected = settings.repeatCount == opt.$1;
        return FilterChip(
          label: Text(opt.$2),
          selected: selected,
          onSelected: (_) {
            settings.setRepeatCount(opt.$1);
            BackgroundService.updateRepeatCount(opt.$1);
          },
        );
      }).toList(),
    );
  }
}

class _QuietHoursCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final alarm = context.watch<AlarmService>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: Text(l10n.enableQuietHours, style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(l10n.disableAnnouncements),
              value: alarm.quietModeEnabled,
              onChanged: alarm.setQuietModeEnabled,
            ),
            if (alarm.quietModeEnabled) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TimeButton(
                      label: l10n.quietStartTime,
                      time: alarm.quietStartTimeString,
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(hour: alarm.quietStartHour, minute: alarm.quietStartMinute),
                        );
                        if (picked != null) alarm.setQuietStartTime(picked.hour, picked.minute);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TimeButton(
                      label: l10n.quietEndTime,
                      time: alarm.quietEndTimeString,
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(hour: alarm.quietEndHour, minute: alarm.quietEndMinute),
                        );
                        if (picked != null) alarm.setQuietEndTime(picked.hour, picked.minute);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({required this.label, required this.time, required this.onTap});
  final String label;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label: $time',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(time, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
