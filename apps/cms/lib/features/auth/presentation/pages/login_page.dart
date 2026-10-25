import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../../../common/failure_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    context.read<AuthCubit>().login(_username.text, _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = context.watch<AuthCubit>().state;
    final submitting = state is AuthUnauthenticated && state.submitting;
    final message = switch (state) {
      AuthUnauthenticated(failure: ForbiddenFailure()) => l10n.cmsAdminOnly,
      AuthUnauthenticated(failure: final f?) => failureText(context, f),
      AuthUnauthenticated(expired: true) => l10n.sessionExpired,
      _ => null,
    };

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Space.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: AutofillGroup(
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l10n.loginTitle, style: theme.textTheme.headlineSmall),
                      const SizedBox(height: Space.sm),
                      Text(l10n.loginSubtitle, style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      )),
                      const SizedBox(height: Space.xl),
                      AppTextField(
                        label: l10n.username,
                        controller: _username,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.username],
                        validator: (v) => validationText(context, Validators.username(v)),
                      ),
                      const SizedBox(height: Space.lg),
                      AppTextField(
                        label: l10n.password,
                        controller: _password,
                        password: true,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        validator: (v) => validationText(context, Validators.password(v)),
                        onSubmitted: (_) => _submit(),
                      ),
                      if (message != null) ...[
                        const SizedBox(height: Space.lg),
                        Semantics(
                          liveRegion: true,
                          child: Text(message, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
                        ),
                      ],
                      const SizedBox(height: Space.xl),
                      AppButton(label: l10n.signIn, onPressed: _submit, loading: submitting, large: true, expand: true),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
