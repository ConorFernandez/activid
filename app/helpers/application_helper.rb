module ApplicationHelper

  def cms_site
    @cms_site ||= default_cms_site
  end

  def cms_info_pages
    info_page = cms_site.pages.where(label: 'Information').first
    info_page.children.published
  end

  def current_page_title
    # Only one of these will have a value at any given time.
    content_for(:page_title) || @cms_page.try(:label)
  end

  protected

  def default_cms_site
    Cms::Site.where(label: 'Activid').first
  end
end
