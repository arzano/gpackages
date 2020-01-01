FROM gentoo/rails:latest

# Needed for changelogs.
RUN git clone https://anongit.gentoo.org/git/repo/gentoo.git /mnt/packages-tree/gentoo/

# Copy code into place.
COPY ./ /var/www/packages.gentoo.org/htdocs/
WORKDIR /var/www/packages.gentoo.org/htdocs/
RUN bundler install

# Git clones here.
RUN cp /var/www/packages.gentoo.org/htdocs/config/secrets.yml.dist /var/www/packages.gentoo.org/htdocs/config/secrets.yml
RUN sed -i 's/set_me/ENV["SECRET_KEY_BASE"]/'g /var/www/packages.gentoo.org/htdocs/config/secrets.yml
RUN cp /var/www/packages.gentoo.org/htdocs/config/initializers/kkuleomi_config.rb.dist /var/www/packages.gentoo.org/htdocs/config/initializers/kkuleomi_config.rb

# Precompile our assets.
RUN bundle exec rake assets:precompile
CMD ["bundler", "exec", "thin", "start"]
