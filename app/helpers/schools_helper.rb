module SchoolsHelper

  def gravatar_for(school, size: 80)
    gravatar_id = Digest::MD5::hexdigest(school.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: school.name, class: "gravatar")
  end
end
