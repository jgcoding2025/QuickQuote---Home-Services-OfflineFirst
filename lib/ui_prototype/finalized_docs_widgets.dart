part of '../ui_prototype.dart';

class FinalizedDocumentsSection extends StatelessWidget {
  const FinalizedDocumentsSection({
    super.key,
    required this.quoteId,
  });

  final String quoteId;

  @override
  Widget build(BuildContext context) {
    final repo = AppDependencies.of(context).finalizedDocumentsRepository;
    return Card(
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(
          'Documents',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        children: [
          StreamBuilder<List<FinalizedDocument>>(
            stream: repo.streamForQuote(quoteId),
            builder: (context, snapshot) {
              final docs = snapshot.data ?? const <FinalizedDocument>[];
              if (docs.isEmpty) {
                return const Text('No finalized documents yet.');
              }
              return Column(
                children: docs
                    .map(
                      (doc) => Card(
                        child: ListTile(
                          leading: Icon(
                            doc.docType == 'invoice'
                                ? Icons.receipt_long
                                : Icons.description_outlined,
                          ),
                          title: Text(doc.title),
                          subtitle: Text(
                            'Created ${_formatTimestamp(doc.createdAt)} • ${doc.status}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _openFinalizedDocument(context, doc),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FinalizedDocumentViewerPage extends StatefulWidget {
  const FinalizedDocumentViewerPage({
    super.key,
    required this.document,
  });

  final FinalizedDocument document;

  @override
  State<FinalizedDocumentViewerPage> createState() =>
      _FinalizedDocumentViewerPageState();
}

class _FinalizedDocumentViewerPageState
    extends State<FinalizedDocumentViewerPage> {
  late Future<Uint8List> _bytesFuture;

  @override
  void initState() {
    super.initState();
    _bytesFuture = File(widget.document.localPath).readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.document.title)),
      body: FutureBuilder<Uint8List>(
        future: _bytesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Unable to load PDF.'));
          }
          return PdfPreview(
            build: (_) async => snapshot.data!,
            canChangePageFormat: false,
            canChangeOrientation: false,
            canDebug: false,
          );
        },
      ),
    );
  }
}

void _openFinalizedDocument(
  BuildContext context,
  FinalizedDocument document,
) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => FinalizedDocumentViewerPage(document: document),
    ),
  );
}

String _formatTimestamp(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final mm = date.month.toString().padLeft(2, '0');
  final dd = date.day.toString().padLeft(2, '0');
  final yyyy = date.year.toString();
  final hh = date.hour.toString().padLeft(2, '0');
  final min = date.minute.toString().padLeft(2, '0');
  return '$mm/$dd/$yyyy $hh:$min';
}
