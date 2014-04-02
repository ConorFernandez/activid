module ApplicationHelper

  def cms_site
    @cms_site ||= default_cms_site
  end

  def cms_info_pages
    info_page = cms_site.pages.where(label: 'Information').first
    info_page.children.published
  end

  protected

  def default_cms_site
    Cms::Site.where(label: 'Activid').first
  end
end
