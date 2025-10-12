from .models import SiteImage

def site_images(request):
    images = SiteImage.objects.all()
    image_dict = {image.key: image.image for image in images}
    return {'site_images': image_dict}
