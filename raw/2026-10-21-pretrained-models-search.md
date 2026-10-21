# Pretrained models for aerial imagery: web search notes

Captured 2026-10-21 from web search results (snippets). Verify versions and licences before use.

## TorchGeo / SatlasPretrain
- TorchGeo groups pretrained weights by sensor, including NAIP: https://torchgeo.readthedocs.io/en/stable/tutorials/pretrained_weights.html
- NAIP RGB weights in TorchGeo are Satlas Swin V2-B, single-image (3 channels); a multi-image NAIP_RGB_MI_SATLAS also exists (Swin_V2_B):
  https://torchgeo.readthedocs.io/en/latest/_modules/torchgeo/models/swin.html , https://geowombat.readthedocs.io/en/latest/dl.html
- Satlas = Swin V2 models pretrained on Sentinel-2 and NAIP: https://www.osgeo.org/community-news/torchgeo-release-v0-7-0/
- SatlasPretrain backbones: Swin-v2-Base, Swin-v2-Tiny, ResNet50, ResNet152 (Allen AI):
  https://allenai.org/blog/satlaspretrain-models-foundation-models-for-satellite-and-aerial-imagery-1679ebe4bbfb
- ResNet weights in TorchGeo exist for Sentinel-2, Landsat, Sentinel-1 and fMoW; no NAIP ResNet was found (third-party table).

## Ultralytics YOLO OBB (DOTAv1)
- https://docs.ultralytics.com/tasks/obb : YOLO11 OBB models (-obb suffix, e.g. yolo11n-obb.pt) are pretrained on DOTAv1 and download automatically.
- YOLO11n-obb: 1024 px input, 78.4 mAP50 on DOTAv1 test, 2.7 M params, 17.2 B FLOPs. YOLO11l-obb: 81.0 mAP50, about 26 M params. Numbers vary slightly by version.
- Fine-tuning example: YOLO("yolo11n-obb.pt") trained on DOTA8 for 100 epochs at 640 px.

## DINOv3 (Meta, arXiv 2508.10104)
- Satellite backbone pretrained on SAT-493M: 493 M 512x512 crops of Maxar RGB orthorectified imagery at 0.6 m.
  https://huggingface.co/facebook/dinov3-vit7b16-pretrain-lvd1689m , https://aiwiki.ai/wiki/dinov3
- Self-supervised (DINO + iBOT + KoLeo + Gram anchoring); suite from 21 M to 6.7 B params plus ConvNeXt variants.
- On GEO-Bench, ViT-7B pretrained on SAT-493M slightly beats ViT-L on classification and segmentation (secondary source).
