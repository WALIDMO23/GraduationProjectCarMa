import 'package:flutter/material.dart';
import 'package:graduation_project/core/localization/app_strings.dart';

import 'package:graduation_project/logic/providers/locale_provider.dart';
import 'package:graduation_project/logic/providers/services_provider.dart';
import 'package:graduation_project/views/services/request_service_page.dart';
import 'package:graduation_project/core/comeponents/app_background.dart';
import 'package:provider/provider.dart';

class TowingServices extends StatefulWidget {
  const TowingServices({super.key});

  @override
  State<TowingServices> createState() => _TowingServicesState();
}

class _TowingServicesState extends State<TowingServices> {
  int _selectedImageIndex = 0;
  int _selectedServiceIndex = 0;
  final TextEditingController _notesController = TextEditingController();

  final List<String> _images = [
    'assets/images/towing.jpeg',
    'assets/images/towinga.jpeg',
    'assets/images/towingb.jpeg',
    'assets/images/towingc.jpeg',
    'assets/images/towingd.jpeg',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = appStrings(context.watch<LocaleProvider>().isArabic);
    final svcProvider = context.watch<ServicesProvider>();
    // Each option multiplies the API base price (ID 6 = 600 EGP)
    const optMult = [1.0, 0.75, 1.25];
    final baseP = svcProvider.serviceById(6)?.price ?? 600.0;
    final optionPrices = optMult.map((m) => (baseP * m).round()).toList();
    final displayPrice = svcProvider.isLoading
        ? (s.isArabic ? '╪ش╪د╪▒┘è ╪د┘╪ز╪ص┘à┘è┘...' : 'Loading...')
        : '${optionPrices[_selectedServiceIndex]} ${s.isArabic ? '╪ش┘┘è┘ç' : 'EGP'}';
    final topPad = MediaQuery.of(context).padding.top;
    final imageH = 300.0 + topPad;
    const double overlapH = 50;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ظ¤ظ¤ Fixed background image ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageH + 30,
            child: Image.asset(
              _images[_selectedImageIndex],
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          // ظ¤ظ¤ CustomScrollView (transparent header + content card) ظ¤ظ¤ظ¤ظ¤
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              // SliverAppBar contains gradient + thumbnails
              // They scroll with the header ظْ disappear behind card when scrolled up
              SliverAppBar(
                expandedHeight: imageH - overlapH,
                pinned: false,
                floating: false,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                forceMaterialTransparency: true,
                automaticallyImplyLeading: false,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Gradient overlay at bottom of image area
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 120,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.70),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Thumbnails ظ¤ inside FlexibleSpaceBar ظْ scroll with header
                      Positioned(
                        bottom: 14,
                        left: 0,
                        right: 0,
                        height: 62,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _images.length,
                          itemBuilder: (_, index) {
                            final isSelected = _selectedImageIndex == index;
                            return GestureDetector(
                              onTap:
                                  () => setState(
                                    () => _selectedImageIndex = index,
                                  ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 56,
                                height: 56,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.white.withValues(
                                              alpha: 0.35,
                                            ),
                                    width: isSelected ? 2.5 : 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Opacity(
                                    opacity: isSelected ? 1.0 : 0.7,
                                    child: Image.asset(
                                      _images[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content card (slides over image as user scrolls)
              SliverToBoxAdapter(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: AppBackground(
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ظ¤ظ¤ Title + price ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.towing,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    s.towingSub,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    s.isArabic ? '╪د┘╪│╪╣╪▒' : 'Price',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    displayPrice,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        Divider(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 16),

                        // ظ¤ظ¤ Service Details ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
                        Text(
                          s.isArabic ? '╪ز┘╪د╪╡┘è┘ ╪د┘╪«╪»┘à╪ر' : 'Service Details',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 14),

                        ..._buildOptions(context, s, optionPrices),

                        const SizedBox(height: 24),

                        // ظ¤ظ¤ Notes ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
                        Text(
                          s.isArabic
                              ? '┘à┘╪د╪ص╪╕╪د╪ز ╪ح╪╢╪د┘┘è╪ر (╪د╪«╪ز┘è╪د╪▒┘è)'
                              : 'Additional Notes (Optional)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _notesController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText:
                                s.isArabic
                                    ? '╪د┘â╪ز╪ذ ┘à┘â╪د┘┘â ╪د┘╪ص╪د┘┘è ┘ê╪د┘┘ê╪ش┘ç╪ر╪î ╪ث┘ê ╪ز┘╪د╪╡┘è┘ ╪ث╪«╪▒┘ë...'
                                    : 'Write your current location, destination, or other details...',
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ظ¤ظ¤ Book button (inside content ظْ no keyboard issue) ظ¤
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              final options = [
                                s.isArabic ? '┘ê┘╪┤ ╪ح┘┘é╪د╪░ ┘à╪│╪╖╪ص' : 'Flatbed Tow Truck',
                                s.isArabic ? '┘ê┘╪┤ ╪│╪ص╪ذ (╪┤┘ê┘â┘ç)' : 'Wheel-Lift Tow Truck',
                                s.isArabic ? '┘ê┘╪┤ ┘ç┘è╪»╪▒┘ê┘┘è┘â' : 'Hydraulic Tow Truck',
                              ];
                              final selectedSub = options[_selectedServiceIndex];
                              final currency = s.isArabic ? '╪ش┘┘è┘ç' : 'EGP';
                              final fullServiceName = '${s.towing}\n$selectedSub - ${optionPrices[_selectedServiceIndex]} $currency';

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => RequestServicePage(
                                        serviceName: fullServiceName,
                                        serviceId: 6,
                                        subServiceId: _selectedServiceIndex + 1,
                                        serviceIcon: Icons.fire_truck_rounded,
                                        serviceColor: Theme.of(context).colorScheme.primary,
                                        notes: _notesController.text.trim(),
                                      ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.fire_truck_rounded,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  s.isArabic
                                      ? '╪د┘╪ز╪د┘┘è: ╪ز╪ص╪»┘è╪» ╪د┘╪ز┘╪د╪╡┘è┘'
                                      : 'Next: Set Details',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ],
          ),

          // ظ¤ظ¤ Fixed back button (always visible) ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
          Positioned(
            top: topPad + 8,
            left: 12,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  List<Widget> _buildOptions(BuildContext context, AppStrings s, List<int> prices) {
    final options = [
      (
        title: s.isArabic ? '┘ê┘╪┤ ╪ح┘┘é╪د╪░ ┘à╪│╪╖╪ص' : 'Flatbed Tow Truck',
        sub: s.isArabic ? '┘à┘╪د╪│╪ذ ┘┘╪│┘è╪د╪▒╪د╪ز ╪د┘┘à╪╣╪╖┘╪ر ╪ذ╪د┘┘â╪د┘à┘' : 'Suitable for completely broken down cars',
      ),
      (
        title: s.isArabic ? '┘ê┘╪┤ ╪│╪ص╪ذ (╪┤┘ê┘â┘ç)' : 'Wheel-Lift Tow Truck',
        sub: s.isArabic ? '┘┘╪│╪ص╪ذ ╪د┘╪│╪▒┘è╪╣ ╪»╪د╪«┘ ╪د┘┘à╪»┘è┘╪ر' : 'For quick towing inside the city',
      ),
      (
        title: s.isArabic ? '┘ê┘╪┤ ┘ç┘è╪»╪▒┘ê┘┘è┘â' : 'Hydraulic Tow Truck',
        sub: s.isArabic ? '┘┘╪│┘è╪د╪▒╪د╪ز ╪د┘╪▒┘è╪د╪╢┘è╪ر ┘ê╪د┘┘à┘╪«┘╪╢╪ر' : 'For sports and low cars',
      ),
    ];

    return List.generate(options.length, (index) {
      final isSelected = _selectedServiceIndex == index;
      return GestureDetector(
        onTap: () => setState(() => _selectedServiceIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
                    : Theme.of(context).colorScheme.surface,
            border: Border.all(
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                    width: 2,
                  ),
                ),
                child:
                    isSelected
                        ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                        : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      options[index].title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      options[index].sub,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${prices[index]}\n${s.isArabic ? '╪ش┘┘è┘ç' : 'EGP'}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    });
  }
}
