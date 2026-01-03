part of '../ui_prototype.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _orgNameController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  bool _canClaimDemo = false;
  bool _loadedClaimable = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedClaimable) {
      return;
    }
    _loadedClaimable = true;
    _loadClaimableDemo();
  }

  @override
  void dispose() {
    _orgNameController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  Future<void> _loadClaimableDemo() async {
    final deps = AppDependencies.of(context);
    final canClaim = await deps.appController.canClaimDemoOrg();
    if (!mounted) {
      return;
    }
    setState(() {
      _canClaimDemo = canClaim;
    });
  }

  Future<void> _createOrg() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final deps = AppDependencies.of(context);
      await deps.appController.createOrganization(
        name: _orgNameController.text.trim(),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _joinWithInvite() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final deps = AppDependencies.of(context);
      await deps.appController.joinWithInviteCode(
        _inviteCodeController.text,
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _claimDemoOrg() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final deps = AppDependencies.of(context);
      await deps.appController.claimDemoOrg();
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set up your organization')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              shrinkWrap: true,
              children: [
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Organization',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _orgNameController,
                          decoration: const InputDecoration(
                            labelText: 'Organization name',
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _isLoading ? null : _createOrg,
                            child: const Text('Create Organization'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Join with Invite Code',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _inviteCodeController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            labelText: 'Invite code',
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _isLoading ? null : _joinWithInvite,
                            child: const Text('Join Organization'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_canClaimDemo) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Claim existing demo-org',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Claim the existing demo org if it has no members.',
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _isLoading ? null : _claimDemoOrg,
                              child: const Text('Claim demo-org'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
