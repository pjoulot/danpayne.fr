<?php

namespace Drupal\dan_payne_twitter_timeline\Plugin\Block;

use Drupal\Core\Block\BlockBase;
use Drupal\Core\Block\BlockPluginInterface;
use Drupal\Core\Form\FormStateInterface;

/**
 * Provides a 'Twitter Timeline' Block
 *
 * @Block(
 *   id = "twitter_timeline_block",
 *   admin_label = @Translation("Twitter Timeline"),
 * )
 */
class TwitterTimelineBlock extends BlockBase implements BlockPluginInterface {
  /**
   * {@inheritdoc}
   */
  public function build() {

    $config = $this->getConfiguration();
    $twitter_account = "";
    if (!empty($config['twitter_timeline_block_account'])) {
      $twitter_account = $config['twitter_timeline_block_account'];
    }
    
    $language = \Drupal::languageManager()->getCurrentLanguage()->getId();
    
    return array(
      '#theme' => 'twitter_timeline_block',
      '#account_name' => $twitter_account,
      '#language' => $language
    );
  }

  /**
   * {@inheritdoc}
   */
  public function blockForm($form, FormStateInterface $form_state) {
    $form = parent::blockForm($form, $form_state);
  
    $config = $this->getConfiguration();

    $form['twitter_timeline_block_settings'] = array (
      '#type' => 'textfield',
      '#title' => $this->t('Twitter account'),
      '#description' => $this->t('The tweets displayed in the block come from this Twitter account.'),
      '#default_value' => isset($config['twitter_timeline_block_account']) ? $config['twitter_timeline_block_account'] : ''
    );
  
    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function blockSubmit($form, FormStateInterface $form_state) {
    $account_name = $form_state->getValue('twitter_timeline_block_settings');
    // Remove the @ if it's the first caracter.
    if(!empty($account_name)) {
      $first_letter = substr($account_name, 0, 1);
      if ($first_letter === "@") {
        $account_name = substr($account_name, 1, strlen($account_name) - 1);
      }
    }
    $this->setConfigurationValue('twitter_timeline_block_account', $account_name);
  }
}
