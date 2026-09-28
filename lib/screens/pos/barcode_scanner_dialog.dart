import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../providers/inventory_provider.dart';

class BarcodeScannerDialog extends StatefulWidget {
  final bool initialContinuousMode;
  final Function(String barcode)? onBarcodeScanned;
  final String title;

  const BarcodeScannerDialog({
    super.key,
    this.initialContinuousMode = false,
    this.onBarcodeScanned,
    this.title = 'Scan Barcode',
  });

  @override
  State<BarcodeScannerDialog> createState() => _BarcodeScannerDialogState();
}

class _BarcodeScannerDialogState extends State<BarcodeScannerDialog>
    with SingleTickerProviderStateMixin {
  late MobileScannerController _scannerController;
  final TextEditingController _manualInputController = TextEditingController();
  final FocusNode _manualFocusNode = FocusNode();

  late bool _isContinuousMode;
  int _scannedCount = 0;
  String? _lastDetectedBarcode;
  DateTime _lastDetectionTime = DateTime.now().subtract(const Duration(seconds: 5));

  bool _isTorchOn = false;
  bool _hasCameraError = false;
  String _cameraErrorMessage = '';

  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _isContinuousMode = widget.initialContinuousMode;

    _scannerController = MobileScannerController(
      formats: const [
        BarcodeFormat.ean13,
        BarcodeFormat.ean8,
        BarcodeFormat.upcA,
        BarcodeFormat.upcE,
        BarcodeFormat.code128,
        BarcodeFormat.code39,
        BarcodeFormat.code93,
        BarcodeFormat.itf14,
        BarcodeFormat.qrCode,
      ],
      detectionSpeed: DetectionSpeed.noDuplicates,
      returnImage: false,
    );

    _animController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _scannerController.dispose();
    _manualInputController.dispose();
    _manualFocusNode.dispose();
    super.dispose();
  }

  void _handleBarcodeDetection(String rawCode) {
    final code = rawCode.trim();
    if (code.isEmpty) return;

    final now = DateTime.now();
    // Debounce duplicate detections of same barcode within 1.5 seconds
    if (_lastDetectedBarcode == code &&
        now.difference(_lastDetectionTime).inMilliseconds < 1500) {
      return;
    }

    _lastDetectedBarcode = code;
    _lastDetectionTime = now;

    if (_isContinuousMode && widget.onBarcodeScanned != null) {
      setState(() {
        _scannedCount++;
      });
      widget.onBarcodeScanned!(code);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Scanned: $code (Item added)'),
          duration: const Duration(milliseconds: 1000),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.teal,
        ),
      );
    } else {
      Navigator.of(context).pop(code);
    }
  }

  void _toggleTorch() async {
    try {
      await _scannerController.toggleTorch();
      setState(() {
        _isTorchOn = !_isTorchOn;
      });
    } catch (_) {}
  }

  void _switchCamera() async {
    try {
      await _scannerController.switchCamera();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final inventory = context.watch<InventoryProvider>();
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 720),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.teal,
                child: Row(
                  children: [
                    const Icon(Icons.qr_code_scanner, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _isContinuousMode
                                ? 'Continuous Mode • $_scannedCount items scanned'
                                : 'Single Scan Mode',
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(_isTorchOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
                      tooltip: 'Toggle Flashlight',
                      onPressed: _toggleTorch,
                    ),
                    IconButton(
                      icon: const Icon(Icons.cameraswitch_outlined, color: Colors.white),
                      tooltip: 'Switch Camera',
                      onPressed: _switchCamera,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      tooltip: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Camera Viewfinder / Preview Area
              Expanded(
                flex: 5,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_hasCameraError)
                      Container(
                        color: Colors.black87,
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.videocam_off_outlined, color: Colors.white70, size: 48),
                              const SizedBox(height: 12),
                              const Text(
                                'Camera scanner unavailable',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _cameraErrorMessage.isNotEmpty
                                    ? _cameraErrorMessage
                                    : 'Please use manual barcode entry or hardware USB barcode scanner below.',
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      MobileScanner(
                        controller: _scannerController,
                        onDetect: (capture) {
                          for (final barcode in capture.barcodes) {
                            if (barcode.rawValue != null) {
                              _handleBarcodeDetection(barcode.rawValue!);
                              break;
                            }
                          }
                        },
                        errorBuilder: (context, error) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted && !_hasCameraError) {
                              setState(() {
                                _hasCameraError = true;
                                _cameraErrorMessage = error.errorDetails?.message ?? error.errorCode.name;
                              });
                            }
                          });
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),

                    // Viewfinder Reticle & Animated Laser Line
                    if (!_hasCameraError)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final scanBoxSize = constraints.maxWidth * 0.7;
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              // Semi-transparent backdrop overlay
                              ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withValues(alpha: 0.5),
                                  BlendMode.srcOut,
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                        backgroundBlendMode: BlendMode.dstOut,
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        width: scanBoxSize,
                                        height: scanBoxSize * 0.65,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Viewfinder Target Frame
                              Container(
                                width: scanBoxSize,
                                height: scanBoxSize * 0.65,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.tealAccent, width: 2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Stack(
                                  children: [
                                    // Animated Laser Line
                                    AnimatedBuilder(
                                      animation: _animation,
                                      builder: (context, child) {
                                        return Positioned(
                                          top: (scanBoxSize * 0.65) * _animation.value,
                                          left: 8,
                                          right: 8,
                                          child: Container(
                                            height: 2,
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.redAccent.withValues(alpha: 0.8),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              // Instruction Pill
                              Positioned(
                                bottom: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.crop_free, color: Colors.tealAccent, size: 16),
                                      SizedBox(width: 6),
                                      Text(
                                        'Place barcode inside frame',
                                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              ),

              // Bottom Controls: Mode Selector & Manual/Hardware Input
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Mode Toggle & Finish Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Switch(
                              value: _isContinuousMode,
                              onChanged: (val) {
                                setState(() {
                                  _isContinuousMode = val;
                                });
                              },
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Continuous Scan',
                              style: TextStyle(
                                fontWeight: _isContinuousMode ? FontWeight.bold : FontWeight.normal,
                                color: _isContinuousMode ? Colors.teal : null,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        if (_isContinuousMode)
                          FilledButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.check, size: 16),
                            label: Text('Done ($_scannedCount)'),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Manual / USB Scanner Text Field
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _manualInputController,
                            focusNode: _manualFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Enter barcode manually or scan with USB gun...',
                              prefixIcon: const Icon(Icons.keyboard, size: 18),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () {
                                  _handleBarcodeDetection(_manualInputController.text);
                                  _manualInputController.clear();
                                },
                              ),
                            ),
                            onSubmitted: (val) {
                              _handleBarcodeDetection(val);
                              _manualInputController.clear();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Quick Test Sample Barcodes
                    Row(
                      children: [
                        const Text('Quick Test: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: inventory.allProducts.take(4).map((p) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: ActionChip(
                                    avatar: const Icon(Icons.qr_code, size: 14),
                                    label: Text('${p.name.split(" ").first} (${p.barcode.substring(p.barcode.length > 4 ? p.barcode.length - 4 : 0)})',
                                        style: const TextStyle(fontSize: 10)),
                                    onPressed: () => _handleBarcodeDetection(p.barcode),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
